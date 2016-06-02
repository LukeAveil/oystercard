#Oystercard test file.
require 'oystercard'

describe Oystercard do	
  subject(:oystercard) {described_class.new}
  let(:station_in) {double(:station_in)}
  let(:station_out) {double(:station_out)}
  

  describe "Attributes" do

  	it "has a default balance of 0" do
        expect(oystercard.balance).to eq 0
   	end

   	# it "Each oystercard is initialized as not in journey" do
    #   expect(oystercard.in_journey?).to be false
    # end

  end

  describe "touch_in" do

    it "Will not allow touch_in if balance is less than minimum fare" do
    	expect {oystercard.touch_in(station_in)}.to raise_error "ERROR: Insufficient funds"
    end

   

    it "Remembers station when touched in" do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE) 
      oystercard.touch_in(station_in)
      expect(oystercard.entry_station).to eq station_in
    end

  end	

  describe "touch_out" do

  

    it "charges card on touch out" do
    	expect {oystercard.touch_out(station_out)}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_FARE)
    end

    it 'forgets entry_station on touch out' do
    	oystercard.touch_out(station_out)
    	expect(oystercard.entry_station).to be nil
    end

    it 'remembers station when touched out' do
    	oystercard.touch_out(station_out)
    	expect(oystercard.exit_station).to eq station_out
    end

  end

  describe "top_up" do

    it "Tops up the balance with the amount passed to top_up" do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      expect(oystercard.balance).to eq Oystercard::MAXIMUM_BALANCE
    end

    it "Refuses balance over 90" do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      expect {oystercard.top_up(1)}.to raise_error "ERROR: Balance limit is £ #{Oystercard::MAXIMUM_BALANCE}"
    end

  end 

  describe "Journey History" do

  	it 'creates an empty journey_history' do
  		oystercard = Oystercard.new
  		expect(oystercard.journey_history.empty?).to eq true
  	end

  	it 'creates a journey_history hash' do
  		expect(oystercard.journey_history).to respond_to (:empty?)
  	end

  	it 'adds entry_station and exit_station to journey_history when user touches out' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
  		oystercard.touch_in(station_in)
  		oystercard.touch_out(station_out)
  		expect(oystercard.journey_history).to eq ({ station_in => station_out })
  	end

  end

end