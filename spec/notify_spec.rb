# frozen_string_literal: true

require "capcap/docker"

RSpec.describe Telegram do
  it "parse columns" do
    text = <<-COLUMNS
      |W| full |W| Project |W| https://github.com
      |W| full |W| Author |W| _MoonLight_
    COLUMNS
    expect(described_class.parse_columns(text))
      .to eq([
               { content: "https://github.com", title: "Project", variant: "full" },
               { content: "_MoonLight_", title: "Author", variant: "full" }
             ])
  end

  it "escape html entities" do
    text = <<~TEXT
      <html-escape>fix: Fix html entities

      1. feat1
      2. feat2

      Co-author: bichle-mechmaster <bich.le@icetea.io></html-escape>
    TEXT
    expect(described_class.html_escape(text)).to eq("fix: Fix html entities&#10;&#10;1. feat1&#10;2. feat2&#10;&#10;Co-author: bichle-mechmaster &lt;bich.le@icetea.io&gt;")
  end

  it "remove trailing whitespace" do
    text = <<-TEXT
      <html-escape>
        http://localhost/dashboard/\nhttp://localhost/grafana/dashboards
      </html-escape>
    TEXT
    expect(described_class.html_escape(text)).to eq(
      "http://localhost/dashboard/&#10;http://localhost/grafana/dashboards"
    )
  end
end
