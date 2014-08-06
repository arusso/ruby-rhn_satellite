module RhnSatellite
  class SystemCustomInfo < RhnSatellite::Connection::Base
    collection 'system.custominfo.listAllKeys'
  end
end
