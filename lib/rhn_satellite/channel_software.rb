module RhnSatellite
  class ChannelSoftware < RhnSatellite::Connection::Base
    
    class << self
      def clone(original_label,name,label,summary,original_state=true,additional_options = {})
        channel_details = {
          'name' => name,
          'label' => label,
          'summary' => summary
        }.merge(additional_options)
        base.default_call('channel.software.clone',original_label,channel_details,original_state)
      end

      def list_children(channel_label)
        base.default_call('channel.software.listChildren',channel_label)
      end
      def list_all_packages(channel_label)
        base.default_call('channel.software.listAllPackages',channel_label)
      end
      def list_all_packages(channel_label,start_date,end_date)
        base.default_call('channel.software.listAllPackages',channel_label,start_date,end_date)
      end

      # Create a software channel
      #
      # +label+:: label of the new channel
      # +name+:: name of the new channel
      # +summary+:: summary of the channel
      # +archlabel+:: the label of the architecture for the channel.
      #   * +channel\-ia32+ - for 32 bit channel architecture
      #   * +channel\-ia64+ - for 64 bit channel architecture
      #   * +channel\-sparc+ - for Sparc channel architecture
      #   * +channel\-alpha+ - for Alpha channel architecture
      #   * +channel\-s390+ - for s390 channel architecture
      #   * +channel\-s390x+ - for s390x channel architecture
      #   * +channel\-iSeries+ - for i-Series architecture
      #   * +channel\-pSeries+ - for p-Series architecture
      #   * +channel\-x86_64+ - for x86_64 channel architecture
      #   * +channel\-ppc+ - for PPC channel architecture
      #   * +channel\-sparc\-sun\-solaris+ - for Sparc Solaris channel
      #                                      architecture
      #   * +channel\-i386\-sun\-solaris+ - for i386 Solaris channel
      #                                     architecture
      # +parentlabel+:: the label of the parent channel or an empty string 
      #                 (default) if it does not have one.
      # +checksumtype+:: checksum type for this channel, used for yum repository
      #                  metadata generation.
      #   * +sha1+ - offers highest compatibility with clients
      #   * +sha256+ - offers highest security, but is compatible with newer
      #                clients e.g. RHEL6 and newer. (default)
      # +gpgkey+:: hash containing the url, id and fingerprint
      #
      def create(label,name,summary,arch,parent_label="",checksum_type="sha256",gpgkey = { })
        gpgkey = {
          'url' => '',
          'id' => '',
          'fingerprint' => ''
        }.merge(gpgkey)
        base.default_call('channel.software.create',
                          label,
                          name,
                          summary,
                          arch,
                          parent_label,
                          checksum_type,
                          gpgkey)
      end

      # Delete a software channel
      #
      # +label+:: Label of software channel to delete
      #
      def delete(label)
        base.default_call('channel.software.delete',label)
      end
    end
  end
end
