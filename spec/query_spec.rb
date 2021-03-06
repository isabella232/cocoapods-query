# frozen_string_literal: true

require 'spec_helper'

describe Pod::Command::Query do
  it 'finds all by default' do
    pods = run
    expect(pods.length).to eq 8
  end

  it 'filters by name' do
    pods = run(['--name=B'])
    expect(pods.length).to eq 1
    expect(pods[0][:name]).to eq 'B'
  end

  it 'filters by dependency' do
    pods = run(['--dependency=H'])
    expect(pods.length).to eq 4
    expect(pods[0][:name]).to eq 'B'
    expect(pods[1][:name]).to eq 'D'
    expect(pods[2][:name]).to eq 'E'
    expect(pods[3][:name]).to eq 'G'
  end

  it 'finds source files by case insensitive substring' do
    pods = run(['--source-file=e.pbobjc.h', '--substring', '--case-insensitive'])
    expect(pods.length).to eq 1
    expect(pods[0][:name]).to eq 'E'
  end

  private

  def run(args = [])
    Pod::Command::Query.new(CLAide::ARGV.new(@args + args)).run
    YAML.safe_load(File.read(@tempfile.path), permitted_classes: [Symbol])
  end
end
