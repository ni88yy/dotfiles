# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/dev/marix/marix-client-js"


# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "marix-client-js"; then

  # Create a new window inline within session layout definition.
  new_window
  run_cmd "vim"
  split_v 30
  split_h 50
  split_v 50
  select_pane 2

fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
