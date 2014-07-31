module RhnSatellite
  class ChannelSoftware < RhnSatellite::Connection::Base

    # API Namespace for this class
    API_NS="channel.software"

    class << self
      # === Description:
      #
      # Clone a channel. If arch_label is omitted, the architecture label of the
      # original channel is used. If parent_label is omitted, the clone becomes
      # a base channel.
      #
      # === Parameters:
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
      #
      # === Returns:
      #
      # * (_int_) cloned channel ID
      #
      # === Example:
      #
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

      # === Description:
      #
      # Lists the children of a channel
      #
      # === Parameters:
      #
      # +label+:: (_string_) parent channel to list children of
      #
      # === Returns:
      #
      # * (_array_)
      #   * (_hash_) - _channel_ _info_
      #     * (_int_) id
      #     * (_string_) name
      #     * (_string_) label
      #     * (_string_) arch_name
      #     * (_string_) summary
      #     * (_string_) description
      #     * (_string_) checksum_label
      #     * (_date_) last_modified
      #     * (_string_) maintainer_name
      #     * (_string_) maintainer_email
      #     * (_string_) maintainer_phone
      #     * (_string_) support_policy
      #     * (_string_) gpg_key_url
      #     * (_string_) gpg_key_id
      #     * (_string_) gpg_key_fp
      #     * (_date_) yumrepo_last_sync (optional)
      #     * (_string_) end_of_life
      #     * (_string_) parent_channel_label
      #     * (_string_) clone_original
      #     * (_array_)
      #       * (_hash_) - _content_ _source_
      #         * (_int_) id
      #         * (_string_) label
      #         * (_string_) sourceUrl
      #         * (_string_) type
      #
      # === Example:
      #
      #   require 'rhn_satellite'
      #
      #   children = RhnSatellite::ChannelSoftware.list_children('rhel-x86_64-server-6')
      #   children.each do |child|
      #     puts "child channel: #{child['label']}"
      #     puts "  content sources:"
      #     child['contentSources'].each do |src|
      #       puts "    - label: #{src['label']}"
      #     end
      #   end
      #
      def list_children(label)
        base.default_call('channel.software.listChildren',label)
      end

      # === Description:
      #
      # List all packages in a channel
      #
      # === Parameters:
      #
      # +label+:: (_string_) Channel label
      # +start_date+:: (_date_) ISO8601 date in which to filter out packages
      #                modified before. (optional)
      # +end_date+:: (_date_) ISO8601 date in which to filter out packages
      #              modified after. Requires +start_date+ to be set. (optional)
      #
      # === Returns:
      #
      # * (_array_)
      #   * (_hash_) - _package_
      #     * (_string_) name
      #     * (_string_) version
      #     * (_string_) release
      #     * (_string_) epoch
      #     * (_string_) checksum
      #     * (_string_) checksum_type
      #     * (_int_) id
      #     * (_string_) arch_label
      #     * (_string_) last_modified_date
      #     * (_string_) last_modified (deprecated)
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

      # === Description:
      #
      # Create a software channel
      #
      # === Parameters:
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
      # === Returns:
      #
      # * (_int_) 1 if the creation succeeded, 0 otherwise
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

      # === Description:
      #
      # Delete a software channel
      #
      # === Parameters:
      #
      # +label+:: (_string_) Label of software channel to delete
      #
      # === Returns:
      #
      # * (_int_) 1 on success, exception thrown otherwise
      #
      # === Example:
      #   require 'rhn_satellite'
      #
      #   RhnSatellite::ChannelSoftware.delete('my-channel-label')
      #
      def delete(label)
        base.default_call('channel.software.delete',label)
      end

      # === Description:
      #
      # Returns details of the given channel as a map
      #
      # === Parameters:
      #
      # +label+:: (_string_) Label of software channel
      #
      # === Returns:
      #
      # * (_hash_)
      #
      def get_details(label)
        base.default_call("#{API_NS}.getDetails",label)
      end

      # === Description:
      #
      # Add a given list of packages to the given channel
      #
      # === Parameters:
      #
      # +label+:: (_string_) channel label
      # +packageIds+:: (_array_) array of package ids
      #
      # === Returns:
      #
      # (_int_) 1 on success, exception thrown otherwise
      #
      def add_packages(label,packages)
        base.default_call("#{API_NS}.addPackages",label,packages)
      end
    end
  end
end
