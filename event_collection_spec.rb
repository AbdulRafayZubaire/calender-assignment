require 'rspec'
require_relative 'event_collection'

describe EventCollection do
  describe 'Basic Crud on Event Collection' do
    before(:example) do
      @events_collection = EventCollection.new
    end
    it 'creates an event' do
      expect(@events_collection.add_event({
                                            title: 'morning',
                                            year: 2024,
                                            month: 7,
                                            date: 22
                                          })).to eq(@events_collection.events.dig(2024, 7, 22)[0])
    end

    # it 'View an event' do
    #   expect(@events_collection.view_event('morning',
    #                                        Date.new(2024, 7, 22))).to eq(@events_collection.events.dig(2024, 7, 22)[0])
    # end

    # it 'Takes input of an event user wants to delete' do
    #   expect(@events_collection.delete_event(Date.new(2024, 7,
    #                                                   22), @events_collection.events.dig(2024, 7, 22), 1)).to eq(true)
    # end

    # it 'View all events of a month' do
    #   expect(@events_collection.display_events_by_month_input(2024, 7)).to eq(@events_collection.events.dig(2024, 7))
    # end

    # it 'View all events of a day' do
    #   expect(@events_collection.get_date_events(Date.new(2024, 7,
    #                                                      22))).to eq(@events_collection.events.dig(2024, 7, 22))
    # end

    # it 'View All Events' do
    #   expect(@events_collection.display_all_events).to eq(@events_collection.events)
    # end

    # it 'creates an event' do
    #   expect(@events_collection.add_event({
    #                                         title: 'morning',
    #                                         year: 2024,
    #                                         month: 7,
    #                                         date: 22
    #                                       })).to eq(@events_collection.events.dig(2024, 7, 22)[0])
    # end

    # it 'Edit an Event' do
    #   expect(@events_collection.edit_event(1,
    #                                        Date.new(2024, 7, 22),
    #                                        { 'attr_to_edit': 'title',
    #                                          'value': 'Afternoon' })).eq to(@events_collection.events.dig(
    #                                            2024, 7, 22
    #                                          )[-1])
    # end
  end
end
