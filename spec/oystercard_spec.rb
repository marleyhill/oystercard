require 'oystercard'

describe Oystercard do
  it 'checks new card has balance' do
    expect(subject.balance).to eq 0
  end

  describe "#top_up" do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up card' do
      expect{ subject.top_up 10 }.to change{ subject.balance }.by 10
    end

    context 'when trying to top up' do
      before { subject.top_up(Oystercard::MAXIMUM_BALANCE) }
      it 'raises error if exceeding top up limit' do
        expect { subject.top_up 1 }.to raise_error "Maximum balance of #{Oystercard::MAXIMUM_BALANCE} exceeded"
      end
    end
  end

  # describe "#deduct" do
  #   it { is_expected.to respond_to(:deduct).with(1).argument }
  #
  #   context 'when deducting amount' do
  #     before { subject.top_up(Oystercard::MAXIMUM_BALANCE) }
  #     it 'can decrease balance' do
  #       expect { subject.deduct 10}.to change{ subject.balance}.by -10
  #     end
  #   end
  # end

  context 'checking if in journey before touch in' do
    it { is_expected.not_to be_in_journey }
  end

  context 'when trying to touch in with no money' do
    before { subject.balance = 0 }
    it 'raises an error' do
      expect { subject.touch_in }.to raise_error "Insufficient balance"
    end
  end

  context 'touching in and out with enough balance' do
    before { subject.balance = Oystercard::MINIMUM_BALANCE }
    it 'confirms card was touched in' do
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it 'confirms card was touched out' do
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end

    it 'deducts amount at touch out' do
      subject.touch_in
      expect { subject.touch_out }.to change { subject.balance }.by (-Oystercard::MINIMUM_BALANCE)
    end
  end

end
