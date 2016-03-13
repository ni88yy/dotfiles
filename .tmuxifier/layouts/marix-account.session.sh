# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/dev/marix/marix-account-service/"


# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "marix-account"; then

  # Create a new window inline within session layout definition.
  new_window
  run_cmd "vim build.sbt"
  split_v 30
  run_cmd "docker-init marix; sbt"
  split_h 50
  run_cmd "docker-init marix; echo; ls; echo; git status"
  split_v 50
  run_cmd "cd ../marix-compose/; docker-init marix; docker-compose logs"
  select_pane 2

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
