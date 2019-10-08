module Paperclip
    class ManualThumbnail < Thumbnail
        
        def make
            if @attachment.instance.respond_to?(:manual_thumb) && @attachment.instance.manual_thumb.present?
                filename = [@basename, @format ? ".#{@format}" : ""].join
                thumb = Tempfile.new(filename)
                thumb.binmode
                thumb << Paperclip.io_adapters.for(@attachment.instance.manual_thumb["image"]).read
                file = thumb
            else
                #puts "respond_to: #{@attachment.instance.respond_to?(:manual_thumb).inspect}"
                #puts "manual_thumb present: #{@attachment.instance.manual_thumb.present?.inspect}"
                puts "using super"
                file = super 
            end
            file
        end
    end
end