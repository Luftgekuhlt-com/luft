module Paperclip
    class RecursiveThumbnail < Thumbnail
        
        def initialize file, options = {}, attachment = nil
            super Paperclip.io_adapters.for(attachment.styles[options[:thumbnail] || :original]), options, attachment
        end
    end
end