# Oystercard Challenge

A program imitating a simple TFL oystercard system.

## User requirements
```
In order to use public transport
As a customer
I want money on my card

In order to keep using public transport
As a customer
I want to add money to my card

In order to protect my money
As a customer
I don't want to put too much money on my card

In order to pay for my journey
As a customer
I need my fare deducted from my card

In order to get through the barriers
As a customer
I need to touch in and out

In order to pay for my journey
As a customer
I need to have the minimum amount for a single journey

In order to pay for my journey
As a customer
I need to pay for my journey when it's complete

In order to pay for my journey
As a customer
I need to know where I've travelled from

In order to know where I have been
As a customer
I want to see to all my previous trips

In order to know how far I have travelled
As a customer
I want to know what zone a station is in

In order to be charged correctly
As a customer
I need a penalty charge deducted if I fail to touch in or out

In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```
## Getting started
- Clone this repo
- Install Gems using `bundle install`

## Usage
```
$ irb

2.6.3 :001 > require './lib/oystercard.rb'
 => true

2.6.3 :002 > oyster = Oystercard.new
 => #<Oystercard:0x00007f87849ade00 @balance=0, @in_use=false, @journey_history=[]>

2.6.3 :003 > oyster.top_up(10)
 => 10

2.6.3 :004 > oyster.touch_in('Aldgate East')
 => {:entry=>"Aldgate East", :exit=>""}

2.6.3 :005 > oyster.touch_out('Kings Cross')
 => [{:entry=>"Aldgate East", :exit=>"Kings Cross"}]

2.6.3 :006 > oyster.balance
 => 9
```

## Running tests
`rspec`
