class MainWindowController < ApplicationController
  set_model 'MainWindowModel'
  set_view 'MainWindowView'
  set_close_action :exit
end
