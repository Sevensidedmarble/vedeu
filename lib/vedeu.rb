# Vedeu is a GUI framework for terminal/console applications written in Ruby.
#
module Vedeu

  # When Vedeu is included within one of your classes, you should have all
  # API methods at your disposal.
  #
  # @example
  #   class YourClassHere
  #     include Vedeu
  #     ...
  #
  def self.included(receiver)
    receiver.send(:include, API)
    receiver.extend(API)
  end

end

$LIB_DIR = File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift($LIB_DIR) unless $LOAD_PATH.include?($LIB_DIR)

require 'date'
require 'forwardable'
require 'io/console'
require 'logger'
require 'optparse'
require 'set'

require 'vedeu/support/exceptions'
require 'vedeu/support/common'
require 'vedeu/configuration/cli'
require 'vedeu/configuration/api'
require 'vedeu/configuration/configuration'
require 'vedeu/support/log'
require 'vedeu/support/trace'

require 'vedeu/models/attributes/coercions'
require 'vedeu/models/attributes/colour_translator'
require 'vedeu/models/attributes/background'
require 'vedeu/models/attributes/foreground'
require 'vedeu/models/attributes/presentation'
require 'vedeu/models/composition'

require 'vedeu/support/position'
require 'vedeu/support/esc'
require 'vedeu/support/terminal'
require 'vedeu/support/event'

require 'vedeu/models/geometry'
require 'vedeu/models/colour'
require 'vedeu/models/style'
require 'vedeu/models/interface'
require 'vedeu/models/cursor'
require 'vedeu/models/keymap'
require 'vedeu/models/line'
require 'vedeu/models/stream'

require 'vedeu/repositories/events'

require 'vedeu/api/defined'
require 'vedeu/api/api'
require 'vedeu/api/composition'
require 'vedeu/api/helpers'
require 'vedeu/api/interface'
require 'vedeu/api/keymap'
require 'vedeu/api/line'
require 'vedeu/api/menu'
require 'vedeu/api/stream'

require 'vedeu/support/keymap_validator'
require 'vedeu/repositories/menus'
require 'vedeu/repositories/keymaps'
require 'vedeu/repositories/interfaces'
require 'vedeu/repositories/groups'
require 'vedeu/repositories/focus'
require 'vedeu/repositories/events'
require 'vedeu/repositories/buffers'
require 'vedeu/repositories/cursors'

require 'vedeu/support/registrar'

require 'vedeu/output/clear'
require 'vedeu/output/compositor'
require 'vedeu/output/refresh'
require 'vedeu/output/render'
require 'vedeu/output/view'

require 'vedeu/support/grid'
require 'vedeu/support/menu'

require 'vedeu/input/input'

require 'vedeu/application'
require 'vedeu/launcher'
