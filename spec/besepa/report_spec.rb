require 'helper'

describe Besepa::Report do

 describe '#all' do
    before do
      stub_get('/reports?page=1').to_return(body: fixture('reports.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a list of reports' do
      reports = Besepa::Report.all(page: 1)
      expect(reports).to respond_to(:each)
      expect(reports.first).to be_an Besepa::Report
      expect(reports.size).to eq(3)
      expect(reports.per_page).to eq(30)
      expect(reports.current_page).to eq(1)
      expect(reports.total).to eq(3)
      expect(reports.pages).to eq(1)
    end
  end

  describe '#find' do
    before do
      stub_get('/reports/rep123456789').to_return(body: fixture('report.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returns a report' do
      report = Besepa::Report.find('rep123456789')
      expect(report).to be_an Besepa::Report
      expect(report.kind).to eq("FullExcelReports")
      expect(report.status).to eq("GENERATED")
    end
  end

  describe '#search' do
    before do
      stub_get('/reports/search?field=group_id&value=foo&page=1').to_return(body: fixture('reports.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'returs a list of reports' do
      reports = Besepa::Report.search(field: 'group_id', value: 'foo', page: 1)
      expect(reports).to respond_to(:each)
      expect(reports.first).to be_an Besepa::Report
      expect(reports.size).to eq(3)
      expect(reports.per_page).to eq(30)
      expect(reports.current_page).to eq(1)
      expect(reports.total).to eq(3)
      expect(reports.pages).to eq(1)
    end
  end

  describe '#download_url' do
    before do
      stub_get("/reports/rep123456789").to_return(body: fixture('report.json'), headers: {content_type: 'application/json; charset=utf-8'})
      stub_get("/reports/rep123456789/download").to_return(body: fixture('report_url.json'), headers: {content_type: 'application/json; charset=utf-8'})
    end

    it "returns download url" do
      report = Besepa::Report.find('rep123456789')
      expect(report.download_url).to eq("url_s3")
    end
  end
end