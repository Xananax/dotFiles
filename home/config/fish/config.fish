set -gx EDITOR vim
set -gx NPM_CONFIG_PREFIX /home/xananax/packages/
set -gx NPM_PACKAGES /home/xananax/.npm-packages
set -gx NODE_PATH $NPM_PACKAGES/lib/node_modules:$NODE_PATH /home/xananax/packages/lib/node_modules
set -gx SYSTEMD_EDITOR vim
set -gx TERMINAL xfce4\x2dterminal
set -gx VISUAL vim
set -gx fish_user_paths $PATH $HOME/.local/bin \
	$HOME/.bin \
	$NPM_PACKAGES/bin
