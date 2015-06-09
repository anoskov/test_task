$: << '..'

require './data_scraper'

describe DataScraper, '#scrape' do

  context "initialize:" do
    it "must raise error if serial number doesnt't set" do
      expect{DataScraper.new}.to raise_error(ArgumentError, /Serial Number doesn't set/)
    end
  end

  context "fetch:" do
    it "must return error message if serial number is invaliid or device not found" do
      @sn = 'bad sn'
      expect(DataScraper.new(@sn).scrape).to eq("Serial number: #{@sn} is invalid or device not found")
    end  
  end

  context "get device info:" do
    it "must generate device_info object in json format if device found" do
      @sn = '013977000323877'
      @right_result = "{\"name\":\"iPhone 5c\",\"serial_number\":\"013977000323877\",\"image_url\":\"https://km.support.apple.com.edgekey.net/kb/securedImage.jsp?configcode=FFHN&size=72x72\",\"registration\":{\"status\":\"true\",\"status_msg\":\"Valid Purchase Date\",\"text\":\"A validated purchase date lets Apple quickly find your product and provide the help you need.\"},\"phone_support\":{\"status\":\"true\",\"status_msg\":\"Telephone Technical Support: Active\",\"text\":\"Your product is eligible for telephone technical support under AppleCare+. Estimated Expiration Date: August 10, 2016 More about AppleCare+\"},\"service_and_repair\":{\"status\":\"true\",\"status_msg\":\"Repairs and Service Coverage: Active (limits apply)\",\"text\":\"Your product is covered for eligible hardware repairs and service under AppleCare+. Estimated Expiration Date: August 10, 2016 Learn about Apple's coverage information for your product.\"}}"
      expect(DataScraper.new(@sn).scrape.to_h.to_json).to eq @right_result
    end
  end  

end