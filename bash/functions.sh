. $LOG_MESSAGE_PATH;

todo() {
  local todo_dir=~/lab/tmp/todos/;
  cd "$todo_dir" 2>/dev/null || { print_message error "Failed to change directory to $todo_dir"; return 1; }

local today_file="TODO.$(date +%Y%m%d).md"
local yesterday_file="TODO.$(date -d "yesterday" +%Y%m%d).md"

if [[ -f "$today_file" ]]; then
    print_message info "Today's TODO file already exists."
    nvim "$today_file"
    return 0
fi

if [[ -f "$yesterday_file" ]]; then
    print_message info "found $yesterday_file";

    grep "\[\]" "$yesterday_file" > "$today_file"
  else
    local latest_file=$(ls -t TODO.*.md 2>/dev/null | head -n 1)
    if [[ -n "$latest_file" ]]; then
      print_message info "found $latest_file";

      grep "\[\]" "$latest_file" > "$today_file"
    else
      print_message info "No TODO files found. Creating an empty TODO file."
      touch "$today_file"
    fi
  fi

  nvim "$today_file"
}

kebab_case() {
    local input_string="$1"
    echo "$input_string" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '"'
}

nvim (){
  folder=$(basename "$PWD")
  echo -ne "\033]0;nvim/$folder\007";
  /usr/local/bin/nvim;
}

function boltdiy_dev() {
  cd /opt/bolt.diy || { echo "Directory /opt/bolt.diy not found."; return 1; }
  
  if [[ "$1" == "install" ]]; then
    pnpm install
  fi
  
  pnpm run dev
}

