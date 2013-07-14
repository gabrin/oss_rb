require 'pry'

require_relative "../spec_helper"
require "yaml"

describe Oss::Index do
  before(:all) do
    @index_name = "test_oss_rb"
    @index = Oss::Index.new(@index_name, ENV['OSS_RB_URL'], ENV['OSS_RB_LOGIN'], ENV['OSS_RB_KEY'])
  end

  describe '#OssIndex(name)' do
    it "should not work with no index name" do
      expect { Oss::Index.new() }.to raise_error
    end
  end

  describe '#OssIndex' do
    it "fetches the OssIndex client object" do
      @index.should be_an_instance_of(Oss::Index)
    end
  end

  describe '#delete index' do
    it "delete index" do
      indexes = @index.delete!
      @index.list.include? @index_name.should == @index_name
    end
  end

  describe '#create index' do
    it "create index" do
      indexes = @index.create('WEB_CRAWLER')
      @index.list.include? @index_name.should == @index_name
    end
  end

  describe '#set fields' do
    it 'set fields' do
      params = {
        'unique' => true,
        'name' => 'id',
        'stored' => true,
        'indexed' => true
      }
      @index.set_field(params)
      params = {
        'default' => true,
        'name' => 'user',
        'analyzer' => 'StandardAnalyzer',
        'stored' => true,
        'indexed' => true
      }
      @index.set_field(params)
    end
  end

  describe '#index docs' do
    it "create index, set fields, index docs" do
      (1..15).each do |i|
        doc = Oss::Document.new("en")
        doc.add_field('id', "#{i}")
        doc.add_field('user', "john#{i}")
        @index.add_document(doc)
      end
      @index.index!
      params = {
        'query_template' => 'search',
        'start' => 0,
        'rows' => 10,
        'returned_field' => ['id', 'user']
      }
      xml = @index.search('user:j*', params);
      docs = xml.css('result doc')
      puts docs
      docs.length.should == 10
    end
  end

  describe '#delete fields' do
    it 'set fields, delete fields' do
      @index.delete_field('host')
      @index.delete_field('subhost')
    end
  end

  describe '#delete document by key' do
    it 'index docs, delete document by key' do
      @index.delete_document_by_key(1)
      @index.delete_document_by_key(2)
      @index.delete_document_by_key(3)
    end

    describe '#delete document by query' do
      it 'index docs, delete document by query' do
        @index.delete_documents_by_query('user:john4')
        @index.delete_documents_by_query('user:john5')
      end
    end
  end

end