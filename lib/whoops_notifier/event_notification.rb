module WhoopsNotifier
  class EventNotification
    class <<self
      attr_accessor :before_send
      
      def before_send(&block)
        @before_send ||= []
        if block_given?
          @before_send << block
        else
          @before_send
        end
      end
    end
    
    attr_accessor :payload
    def send
    end
  end
end