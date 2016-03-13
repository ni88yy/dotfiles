# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/dev/marix/marix-gateway"


# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "marix-gateway"; then

  # Create a new window inline within session layout definition.
  new_window
  run_cmd "vim Dockerfile"
  split_v 20
  run_cmd "docker-init marix; echo; ls; echo; git status"
  select_pane 1

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
