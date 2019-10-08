module Paperclip
    class Uncropped < Thumbnail
        
        def make
            if @attachment.instance.respond_to?(:uncropped) && @attachment.instance.uncropped.present?
                filename = [@basename, @format ? ".#{@format}" : ""].join
                img = Tempfile.new(filename)
                img.binmode
                img << Paperclip.io_adapters.for(@attachment.instance.uncropped["image"]).read
                file = img
                puts "Uncropped:make:#{file.size}"
            else
                file = File.new(@file.path)
            end
            file
        end
    end
end