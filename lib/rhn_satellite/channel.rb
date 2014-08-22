module RhnSatellite
  class Channel < RhnSatellite::Connection::Base
    API_NS="channel"

    collection 'channel.listAllChannels'

    class << self
      def list_my_channels
        base.default_call("#{API_NS}.listMyChannels")
      end

      def list_all_channels
        base.default_call("#{API_NS}.listAllChannels")
      end
    end
  end
end
