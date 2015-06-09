#!/usr/bin/env ruby

# name:            Data_Scraper
# copyright:       © 2015 Andrew Noskov
# author:          Andrew Noskov <flashbulb54@gmail.com>

require 'capybara'

class DataScraper
  include Capybara::DSL

  def initialize(*args)
    Capybara.default_driver = :selenium
    @sn, @fetch_type = args
    raise ArgumentError, "Serial Number doesn't set" unless @sn
  end

  def scrape
    @result = case @fetch_type
                when 'direct' then fetch_page_from_direct_link
                else fetch_page
              end 
    begin           
      get_device_info
    rescue Capybara::ElementNotFound
      "Serial number: #{@sn} is invalid or device not found"
    end  
  end

  private

  def fetch_page
    visit "https://selfsolve.apple.com/agreementWarrantyDynamic.do"
    find('#sn').set(@sn)
    click_button('Continue')
    page
  end

  def fetch_page_from_direct_link
    visit "https://selfsolve.apple.com/wcResults.do?sn=#{@sn}&Continue=Continue&num=0"
    page
  end  

  def get_device_info
    DeviceInfo.from_check_result(@result)
  end

  class DeviceInfo < OpenStruct
    def self.from_check_result(node)
      new(
        name:              node.find("#productname").text,
        serial_number:     node.find("#productsn").text,
        image_url:         node.find("#productimage img")["src"],
        registration: {
          status:          node.find('#registration h3')[:id].match('true|false').to_s,
          status_msg:      node.find('#registration h3').text,
          text:            node.find('#registration-text').text
        },
        phone_support: {
          status:          node.find('#phone h3')[:id].match('true|false').to_s,
          status_msg:      node.find('#phone h3').text,
          text:            node.find('#phone-text').text
        },
        service_and_repair: {
          status:          node.find('#phone h3')[:id].match('true|false|covered').to_s,
          status_msg:      node.find('#hardware h3').text,
          text:            node.find('#hardware-text').text
        }
      )
    end
  end
end