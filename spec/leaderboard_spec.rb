require_relative '../leaderboard.rb'

# frozen_string_literal: true

RSpec.describe Leaderboard  do
  it "groups by offline designations" do
    leaderboard = Leaderboard.new(offline_csv_path: '../offline-donors.csv', online_csv_path: '../online-donors.csv')
    expect(leaderboard.offline_designations).to match({
       "Area of Greatest Need" => {:amount=>37000.0, :donors=>2},
       "Athletics" => {:amount=>150.67, :donors=>1},
       "College of Education" => {:amount=>2000.0, :donors=>1},
       "College of Veterinary Medicine" => {:amount=>19.27, :donors=>1},
       "Mission and Ministry" => {:amount=>2000.0, :donors=>1},
       "Student Financial Aid" => {:amount=>500.0, :donors=>1}
    })
  end

  it "groups by online designations" do
    leaderboard = Leaderboard.new(offline_csv_path: '../offline-donors.csv', online_csv_path: '../online-donors.csv')
    expect(leaderboard.online_designations).to match({
       "Area of Greatest Need" => {:amount=>35000.0, :donors=>1},
       "College of Veterinary Medicine" => {:amount=>1250.0, :donors=>1},
       "Student Financial Aid" => {:amount=>1250.0, :donors=>1}
    })
  end

  it "groups by designations" do
    leaderboard = Leaderboard.new(offline_csv_path: '../offline-donors.csv', online_csv_path: '../online-donors.csv')
    expect(leaderboard.by_designation).to match({
       "Area of Greatest Need" => {:amount=>72000.0, :donors=>3},
       "Athletics" => {:amount=>150.67, :donors=>1},
       "College of Education" => {:amount=>2000.0, :donors=>1},
       "College of Veterinary Medicine" => {:amount=>1269.27, :donors=>2},
       "Mission and Ministry" => {:amount=>2000.0, :donors=>1},
       "Student Financial Aid" => {:amount=>1750.0, :donors=>2}
    })
  end

  # it "groups by offline affiliation" do
  #   leaderboard = Leaderboard.new(offline_csv_path: '../offline-donors.csv', online_csv_path: '../online-donors.csv')
  #   expect(leaderboard.offline_affiliations).to match({
  #     "Parent" => {:amount=>37500.0, donors: 2},
  #     "Alumni" => {:amount=>37500.0, donors: 2}
  #   })
  # end
end

