#!/bin/bash
# Recall relevant garden notes based on user prompt keywords.
# Receives JSON via stdin with user_prompt field.
# Matches prompt words against garden tree nodes using fuzzy linguistic matching.
# Outputs tendr stat results for matching nodes.

# Read the user prompt from stdin JSON
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('user_prompt', ''))
" 2>/dev/null)

if [ -z "$PROMPT" ]; then
  exit 0
fi

# Find the garden (respect TENDR_DIR env var)
GARDEN_DIR="$TENDR_DIR"
if [ -z "$GARDEN_DIR" ] || [ ! -f "$GARDEN_DIR/config.toml" ]; then
  GARDEN_DIR=""
  for dir in $HOME/.claude/projects/*/memory/garden ./garden ./.garden; do
    if [ -f "$dir/config.toml" ]; then
      GARDEN_DIR="$dir"
      break
    fi
  done
fi

if [ -z "$GARDEN_DIR" ]; then
  exit 0
fi

# Get tree node names
NODES=$(cd "$GARDEN_DIR" && tendr tree 2>/dev/null | grep -v "^$" | sed 's/[├│└─|]//g' | sed 's/^[[:space:]]*//')

if [ -z "$NODES" ]; then
  exit 0
fi

# Fuzzy match prompt words against tree nodes
MATCHES=$(PROMPT="$PROMPT" NODES="$NODES" python3 << 'PYEOF'
import sys, re, os

def stem(word):
    """Simple English stemmer (Porter-lite)."""
    word = word.lower().strip()
    suffixes = [
        'ational', 'tional', 'encies', 'ances', 'ments',
        'iness', 'ously', 'ively', 'ation', 'ence', 'ance',
        'ness', 'ment', 'able', 'ible', 'ious', 'eous',
        'ting', 'ing', 'ies', 'ful', 'ous', 'ive',
        'ise', 'ize', 'ity', 'ant', 'ent', 'ist',
        'ism', 'als', 'ers', 'ion', 'ted', 'ly',
        'ed', 'er', 'al', 'es', 's'
    ]
    for suffix in suffixes:
        if len(word) > len(suffix) + 2 and word.endswith(suffix):
            return word[:-len(suffix)]
    return word

prompt = os.environ.get('PROMPT', '')
nodes_raw = os.environ.get('NODES', '')

if not prompt or not nodes_raw:
    sys.exit(0)

# Tokenize prompt: extract words, remove noise
stop_words = {
    'the', 'a', 'an', 'is', 'are', 'was', 'were', 'be', 'been', 'being',
    'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
    'should', 'may', 'might', 'can', 'shall', 'to', 'of', 'in', 'for',
    'on', 'with', 'at', 'by', 'from', 'as', 'into', 'about', 'between',
    'through', 'after', 'before', 'above', 'below', 'up', 'down', 'out',
    'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here',
    'there', 'when', 'where', 'why', 'how', 'all', 'each', 'every',
    'both', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor',
    'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 'just',
    'because', 'but', 'and', 'or', 'if', 'while', 'what', 'which', 'who',
    'this', 'that', 'these', 'those', 'it', 'its', 'i', 'me', 'my', 'we',
    'our', 'you', 'your', 'he', 'she', 'they', 'them', 'his', 'her',
    'ok', 'okay', 'yeah', 'yes', 'no', 'hey', 'hi', 'hello', 'thanks',
    'please', 'tell', 'show', 'give', 'get', 'make', 'let', 'know',
    'think', 'see', 'look', 'want', 'need', 'use', 'try', 'like',
    'also', 'well', 'back', 'now', 'way', 'may', 'say', 'much'
}

prompt_words = re.findall(r'[a-zA-Z]+', prompt.lower())
prompt_words = [w for w in prompt_words if w not in stop_words and len(w) > 2]
prompt_stems = {stem(w): w for w in prompt_words}

# Parse nodes: handle kebab-case
nodes = [n.strip() for n in nodes_raw.strip().split('\n') if n.strip()]
matches = []

for node in nodes:
    node_clean = node.strip()
    if not node_clean:
        continue
    # Split kebab-case node name into parts
    node_parts = node_clean.split('-')
    node_stems = [stem(p) for p in node_parts]

    matched = False
    # Check for matches: any node stem matches any prompt stem
    for ns in node_stems:
        for ps in prompt_stems:
            if ns == ps:
                matched = True
                break
            # Prefix matching (min length 3)
            if len(ps) > 2 and len(ns) > 2:
                if ns.startswith(ps) or ps.startswith(ns):
                    matched = True
                    break
        if matched:
            break

    if not matched:
        # Check full node name against multi-word prompt phrases
        node_joined = node_clean.replace('-', '')
        for pw in prompt_words:
            if len(pw) > 3 and (pw in node_joined or node_joined in pw):
                matched = True
                break

    if matched:
        matches.append(node_clean)

# Deduplicate while preserving order
seen = set()
unique = []
for m in matches:
    if m not in seen:
        seen.add(m)
        unique.append(m)

for m in unique:
    print(m)
PYEOF
)

if [ -z "$MATCHES" ]; then
  exit 0
fi

# Run tendr stat for each match and collect output
echo "--- tendr recall ---"
echo ""
while IFS= read -r node; do
  STAT=$(cd "$GARDEN_DIR" && tendr stat "$node" 2>/dev/null)
  if [ -n "$STAT" ]; then
    echo "$STAT"
    echo ""
  fi
done <<< "$MATCHES"
echo "--- end recall ---"
