# frozen_string_literal: true
require_relative '../leaderboard.rb'

RSpec.describe Leaderboard  do
  let(:leaderboard) { Leaderboard.new(offline_csv_path: '../offline-donors.csv', online_csv_path: '../online-donors.csv') }

  it "groups by offline designations" do
    expect(leaderboard.offline_designations).to match({
       "Area of Greatest Need" => {:amount=>37000.0, :donations=>2, :donors=>2},
       "Athletics" => {:amount=>150.67, :donations=>1, :donors=>1},
       "College of Education" => {:amount=>2000.0, :donations=>1, :donors=>1},
       "College of Veterinary Medicine" => {:amount=>19.27, :donations=>1, :donors=>1},
       "Mission and Ministry" => {:amount=>2000.0, :donations=>1, :donors=>1},
       "Student Financial Aid" => {:amount=>500.0, :donations=>1, :donors=>1}
    })
  end

  it "groups by online designations" do
    expect(leaderboard.online_designations).to match({
       "Area of Greatest Need" => {:amount=>35000.0, :donations=>1, :donors=>1},
       "College of Veterinary Medicine" => {:amount=>1250.0, :donations=>1, :donors=>1},
       "Student Financial Aid" => {:amount=>1250.0, :donations=>1, :donors=>1}
    })
  end

  it "groups by designations" do
    expect(leaderboard.by_designation).to match({
       "Area of Greatest Need" => {:amount=>72000.0, :donations=>3, :donors=>3},
       "Athletics" => {:amount=>150.67, :donations=>1, :donors=>1},
       "College of Education" => {:amount=>2000.0, :donations=>1, :donors=>1},
       "College of Veterinary Medicine" => {:amount=>1269.27, :donations=>2, :donors=>2},
       "Mission and Ministry" => {:amount=>2000.0, :donations=>1, :donors=>1},
       "Student Financial Aid" => {:amount=>1750.0, :donations=>2, :donors=>2}
    })
  end

  it "groups by offline affiliation" do
    expect(leaderboard.offline_affiliations).to match({
      "Alumni" => {:amount=>37019.27, donations:3, donors:2},
      "Friend" => {:amount=>500.0, donations:1, donors:1},
      "Parent" => {:amount=>650.67, donations:2, donors:2},
    })
  end

  it "groups by online affiliation" do
    expect(leaderboard.online_affiliations).to match({
      "Alumni" => {:amount=>37500.0, donations:2, donors:2},
      "Parent" => {:amount=>37500.0, donations:2, donors:2},
    })
  end

  it "groups by affiliation" do
    expect(leaderboard.by_affiliation).to match({
      # some float precision math happening.
      # mabye convert to amount_in_cents or something
      "Alumni" => {:amount=>74519.26999999999, donations:5,donors:4},
      "Friend" => {:amount=>500.0, donations:1, donors:1},
      "Parent" => {:amount=>38150.67, donations:4, donors:4},
    })
  end
end

