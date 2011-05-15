export GK_PROJECT_IDEPS=( \
  "$(pwd)/../ghaki-env" \
  )
export GK_PROJECT_GO_DIRS=( \
  "lib:${GK_PROJECT_DIR}/lib/ghaki/account" \
  "spec:${GK_PROJECT_DIR}/spec/ghaki/account" \
  "bin:${GK_PROJECT_DIR}/bin" \
  )
rvm use '1.9.2@ghaki-account'
