#! /bin/bash

# Save state
save_state_variables() {
  STATE_SAVE_LOCATION=/build/state/
  echo -e "\n*** saving state - variables ***"
  # process each parameter passed in
  for var in "$@"; do
    if [[ ! -z $var ]]; then
      echo "export "$var"_PREVIOUS="${!var} >> $STATE_SAVE_LOCATION/variable_state.env
    else
      echo "variable not found or is empty...state not saved"
    fi
  done
  cat $STATE_SAVE_LOCATION/variable_state.env
}

save_state_files() {
  STATE_SAVE_LOCATION=/build/state/
  echo -e "\n*** saving state - files ***"
  # process each parameter passed in
  for file in "$@"; do
    if [[ -f $file ]]; then
      cp $file $STATE_SAVE_LOCATION
      echo "files saved to state successfully"
    else
      echo "file requested is not found in location specified...state not saved"
    fi
  done
}

# Load state
load_incoming_state_variables() {
  STATE_LOAD_LOCATION=$INCOMING_STATE_PATH
  echo -e "\n*** loading state - variables ***"
  ls -l $STATE_LOAD_LOCATION
  if [[ -f $STATE_LOAD_LOCATION/variable_state.env ]]; then
    source $STATE_LOAD_LOCATION/variable_state.env
    echo "variables loaded to state successfully"
  else
    echo "no state variables to load"
  fi
}
