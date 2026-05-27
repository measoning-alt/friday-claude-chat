#!/bin/bash
# 自动更新聊天记录网站
cd /tmp/chat-site || git clone https://github.com/measoning-alt/friday-claude-chat.git /tmp/chat-site
cd /tmp/chat-site && git pull origin main

# 提取最新聊天记录
PYTHONIOENCODING=utf-8 python3 << 'PYEOF'
import json, os, glob
archived_dir = os.path.expanduser('~/.openclaw/workspace/claude-bridge/inbox/archived')
messages = []
for f in sorted(glob.glob(os.path.join(archived_dir, '*.json'))):
    try:
        with open(f, encoding='utf-8') as fh:
            data = json.load(fh)
            if data.get('from') in ('claude', 'friday') and data.get('msg', '').strip():
                messages.append({
                    'from': data['from'],
                    'msg': data['msg'],
                    'ts': data.get('ts', ''),
                })
    except:
        pass
with open('/tmp/chat-site/chat-data.json', 'w', encoding='utf-8') as out:
    json.dump(messages, out, ensure_ascii=False, indent=2)
print(f'Updated: {len(messages)} messages')
PYEOF

git add . && git commit -m "🔄 自动更新聊天记录 $(date '+%H:%M')" && git push origin main
