#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../spec_helper'

describe RhnSatellite::ChannelSoftware do
  before(:each) do
    RhnSatellite::ChannelSoftware.reset
    conn = Object.new
    conn.stubs(:call)

    XMLRPC::Client.stubs(:new2).returns(conn)

    RhnSatellite::ChannelSoftware.username = 'user'
    RhnSatellite::ChannelSoftware.password = 'pwd'
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.login",'user','pwd').returns("token")
    RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with("auth.logout",'token')
  end

  describe ".clone" do

    it "clones a channel" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.clone",
        "token",
        'old_channel',
        {
          'name' => 'new_channel',
          'label' => 'some_label',
          'summary' => 'summary'
        },
        false
      ).returns("123")

      new_channel = {
        'name' => 'new_channel',
        'label' => 'some_label',
        'summary' => 'summary',
      }
      RhnSatellite::ChannelSoftware.clone('old_channel',new_channel)
    end
    context "with additional options" do
      it "should pass these options" do
        RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
          "channel.software.clone",
          "token",
          'old_channel',
          {
            'name' => 'new_channel',
            'label' => 'some_label',
            'summary' => 'summary',
            'parent_label' => 'blub'
          },
          true
        ).returns("123")

        new_channel = {
          'name' => 'new_channel',
          'label' => 'some_label',
          'summary' => 'summary',
          'parent_label' => 'blub',
        }
        RhnSatellite::ChannelSoftware.clone('old_channel',new_channel,true)
      end
    end
  end

  describe ".list_children" do
    it "lists all children of a software channel" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.listChildren",
        "token",
        'channel_label').returns("123")

      RhnSatellite::ChannelSoftware.list_children('channel_label')
    end
  end

  describe '.list_all_packages' do
    it "lists all packages in a software channel" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.listAllPackages",
        "token",
        'channel_label').returns([
          {
          "name"                => "yum",
          "version"             => "3.2.8",
          "release"             => "9.el5_2.1",
          "epoch"               => "",
          "id"                  => 5337,
          "arch_label"          => "noarch",
          "last_modified_date"  => "2008-05-21 17:34:21",
          "last_modified"       => "2008-05-21 17:34:21"
        }])

      RhnSatellite::ChannelSoftware.list_all_packages('channel_label').first['name'].should eql('yum')
    end

    it "lists all packages in a software channel modified after start_date" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.listAllPackages",
        "token",
        'channel_label',
        Date.parse('1/1/2009')).returns([
          {
          "name"                => "yum",
          "version"             => "3.2.8",
          "release"             => "9.el5_2.1",
          "epoch"               => "",
          "id"                  => 5337,
          "arch_label"          => "noarch",
          "last_modified_date"  => "2009-05-21 17:34:21",
          "last_modified"       => "2009-05-21 17:34:21"
        }])

      RhnSatellite::ChannelSoftware.list_all_packages('channel_label',Date.parse('1/1/2009')).first['name'].should eql('yum')
    end

    it "lists all packages in a software channel modified between start_date and end_date" do
      RhnSatellite::Connection::Handler.any_instance.expects(:make_call).with(
        "channel.software.listAllPackages",
        "token",
        'channel_label',
        Date.parse('1/1/2009'),
        Date.parse('1/1/2014')).returns([
          {
          "name"                => "yum",
          "version"             => "3.2.8",
          "release"             => "9.el5_2.1",
          "epoch"               => "",
          "id"                  => 5337,
          "arch_label"          => "noarch",
          "last_modified_date"  => "2009-05-21 17:34:21",
          "last_modified"       => "2009-05-21 17:34:21"
        }])

      RhnSatellite::ChannelSoftware.list_all_packages('channel_label',
                                                      Date.parse('1/1/2009'),
                                                      Date.parse('1/1/2014')).first['name'].should eql('yum')
    end
  end
end
