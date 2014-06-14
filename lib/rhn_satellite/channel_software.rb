module RhnSatellite
  class ChannelSoftware < RhnSatellite::Connection::Base
    
    # API Namespace for this class
    API_NS="channel.software"

    class << self
      # Clone a channel. If arch_label is omitted, the architecture label of the
      # original channel is used. If parent_label is omitted, the clone becomes
      # a base channel.
      #
      # +original_label+:: (_string_) label of the channel we want to clone from
      # +channel_details+:: (_hash_) details for our new cloned channel
      #                     * (_string_) +name+
      #                     * (_string_) +label+
      #                     * (_string_) +summary+
      #                     * (_string_) +parent_label+ (optional)
      #                     * (_string_) +arch_label+ (optional)
      #                     * (_string_) +gpg_key_url+ (optional)
      #                     * (_string_) +gpg_key_id+ (optional)
      #                     * (_string_) +gpg_key_fp+ (optional)
      #                     * (_string_) +description+ (optional)
      # +original_state+:: (_boolean_) whether to clone just the channel with
      #                    errata (+false+) or without errata (+true+). Default
      #                    is +false+.
      # === Example:
      #   require 'rhn_satellite'
      #
      #   new_channel = {
      #     'name'       => 'RHEL6 Weekly Channel',
      #     'label'      => 'rhel-x86_64-server-6-weekly',
      #     'summary'    => 'RHEL6 Weekly Refresh Channel (x86_64)',
      #     'arch_label' => 'channel-x86_64',
      #   }
      #   RhnSatellite::ChannelSoftware.clone('rhel-x86_64-server-6',new_channel)
      #
      def clone(original_label,channel_details,original_state=false)
        apicall = "#{API_NS}.clone"

        base.default_call(apicall,original_label,channel_details,original_state)
      end

      def list_children(label)
        base.default_call('channel.software.listChildren',label)
      end

      # List all packages in a channel
      #
      # +label+:: Channel label
      # +start_date+:: (_date_) ISO8601 date in which to filter out packages
      #                modified before. (optional)
      # +end_date+:: (_date_) ISO8601 date in which to filter out packages
      #              modified after. Requires +start_date+ to be set. (optional)
      #
      # === Example:
      #   require 'time'
      #   require 'rhn_satellite'
      #
      #   chan = 'rhel-x86_64-server-6'
      #   after = Date.parse('1/1/2009').iso8601
      #   before = Date.parse('1/1/2014').iso8601
      #
      #   # get all packages in 'rhel-x86_64-server-6'
      #   pkgs = RhnSatellite::ChannelSoftware.list_all_packages(chan)
      #
      #   # get all packages modified after 'after' in 'rhel-x86_64-server-6'
      #   pkgs = RhnSatellite::ChannelSoftware.list_all_packages(chan,after)
      #
      #   # get all packages modified after 'after' and before 'before' in
      #   # 'rhel-x86_64-server-6'.
      #   pkgs = RhnSatellite::ChannelSoftware.list_all_packages(chan,after,before)
      #
      def list_all_packages(label,start_date=nil,end_date=nil)
        apicall = "#{API_NS}.listAllPackages"
        if start_date.nil?
          base.default_call(apicall,label)
        elsif end_date.nil?
          base.default_call(apicall,label,start_date)
        else
          base.default_call(apicall,label,start_date,end_date)
        end
      end

      # Create a software channel
      #
      # +label+:: (_string_) label of the new channel
      # +name+:: (_string_) name of the new channel
      # +summary+:: (_string_) summary of the channel
      # +archlabel+:: (_string_) the label of the architecture for the channel
      #               (optional)
      #               * +channel-ia32+:: 32 bit channel architecture
      #               * +channel-ia64+:: 64 bit channel architecture
      #               * +channel-sparc+:: Sparc channel architecture
      #               * +channel-alpha+:: Alpha channel architecture
      #               * +channel-s390+:: s390 channel architecture
      #               * +channel-s390x+:: s390x channel architecture
      #               * +channel-iSeries+:: i-Series architecture
      #               * +channel-pSeries+:: p-Series architecture
      #               * +channel-x86_64+:: x86_64 channel architecture
      #               * +channel-ppc+:: PPC channel architecture
      #               * +channel-sparc-sun-solaris+:: Sparc Solaris channel
      #                                               architecture
      #               * +channel-i386-sun-solaris+:: for i386 Solaris channel
      #                                              architecture
      # +parentlabel+:: (_string_) the label of the parent channel or an empty
      #                 string if it does not have one. The default is an empty
      #                 string.
      # +checksumtype+:: (_string_) checksum type for this channel, used for yum
      #                  repository metadata generation.
      #                  * +sha1+:: offers highest compatibility with clients
      #                  * +sha256+:: offers highest security, but is compatible
      #                               with newer clients e.g. RHEL6 and newer.
      #                               This is the default.
      # +gpgkey+:: (_hash_) information regarding the gpg key
      #            * +url+:: (_string_) GPG key URL. Default is empty string.
      #            * +id+:: (_string_) GPG key ID. Default is empty string
      #            * +fingerprint+:: (_string_) GPG key fingerprint. Default is
      #                              empty string.
      #
      #
      # === Example:
      #   require 'rhn_satellite'
      #
      #   chan = 'my-super-channel-x86_64'
      #   summary = 'My Super Channel - x86_64'
      #   parent = 'my-parent-channel-x86_64'
      #   arch = 'channel-x86_64'
      #   chksum = 'sha256'
      #   gpg = {}
      #
      #   # create a new channel with no parent
      #   RhnSatellite::ChannelSoftware.create(chan,summary,arch,'',chksum,gpg)
      #
      #   # create a new channel with parent channel 'my-parent'
      #   RhnSatellite::ChannelSoftware.create(chan,summary,arch,parent,chksum,gpg)
      #
      def create(label,name,summary,arch,parent_label='',checksum_type='sha256',gpgkey = { })
        apicall = "#{API_NS}.create"
        gpgkey = {
          'url' => '',
          'id' => '',
          'fingerprint' => ''
        }.merge(gpgkey)
        base.default_call(apicall, label, name, summary, arch, parent_label,
                          checksum_type, gpgkey)
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
