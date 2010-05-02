###
# Copyright: Savonix Corporation
# Author: Albert Lash
# License: Affero General Public License v3 or later
##

module SvxBox
  module Sinatricus

    # Just the usual Sinatra redirect with App prefix
    def mredirect(uri)
      redirect settings.uripfx+uri, 301
    end

    def svx_debug(msg='',&block)
      if ENV['RACK_ENV'] == 'development'
        puts block.nil? ? msg : block.call
      end
    end
    def svx_debug_t(msg='',&block)
      if block
        svx_debug { block.call }
      else
        svx_debug(msg)
      end
    end
  end
end
