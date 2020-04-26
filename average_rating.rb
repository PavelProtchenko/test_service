require 'json'
require 'xmlhasher'

class AverageRating
  def initialize
    files = Dir.glob('data/*')
    @content = files.map do |file|
      File.readlines(file)
    end
  end

  def math_data
    data1 = JSON.parse(@content[0].join()).map{|el| el['math']}
    data2 = JSON.parse(@content[1].join())['mathematics'].map{|el| el['grade']}
    
    converted_data = XmlHasher.parse(@content[2].join()).to_json
    selected_data = JSON.parse(converted_data)['root']['row'].map{|el| el['grades']}.flatten
 
    math = selected_data.select do |el|
      case el['subject']
      when 'math'
        el['score']
      end
    end

    data3 = math.map{|el| el['score'].to_i}
    transform_data = data1.zip(data2).zip(data3).flatten.compact

    {
      amount: transform_data.count.to_f,
      sum: transform_data.inject(:+).to_f
    }
  end

  def rus_data
    data1 = JSON.parse(@content[0].join()).map{|el| el['rus']}
    data2 = JSON.parse(@content[1].join())['russian_language'].map{|el| el['grade']}

    converted_data = XmlHasher.parse(@content[2].join()).to_json
    selected_data = JSON.parse(converted_data)['root']['row'].map{|el| el['grades']}.flatten
 
    rus = selected_data.select do |el|
      case el['subject']
      when 'rus'
        el['score']
      end
    end

    data3 = rus.map{|el| el['score'].to_i}
    transform_data = data1.zip(data2).zip(data3).flatten.compact

    {
      amount: transform_data.count.to_f,
      sum: transform_data.inject(:+).to_f
    }
  end

  def phys_data
    data1 = JSON.parse(@content[0].join()).map{|el| el['phys']}
    data2 = JSON.parse(@content[1].join())['physics'].map{|el| el['grade']}

    converted_data = XmlHasher.parse(@content[2].join()).to_json
    selected_data = JSON.parse(converted_data)['root']['row'].map{|el| el['grades']}.flatten
 
    phys = selected_data.select do |el|
      case el['subject']
      when 'phys'
        el['score']
      end
    end

    data3 = phys.map{|el| el['score'].to_i}
    transform_data = data1.zip(data2).zip(data3).flatten.compact

    {
      amount: transform_data.count.to_f,
      sum: transform_data.inject(:+).to_f
    }
  end

  def calculate_average(amount, sum)
    sum / amount
  end

  def show_data
    math_ave = self.calculate_average(self.math_data[:amount], self.math_data[:sum]).round(2)
    rus_ave = self.calculate_average(self.rus_data[:amount], self.rus_data[:sum]).round(2)
    phys_ave = self.calculate_average(self.phys_data[:amount], self.phys_data[:sum]).round(2)

    {
      math: "#{math_ave}",
      russian: "#{rus_ave}",
      physics: "#{phys_ave}"
    }
  end
end

ar = AverageRating.new
pp ar.show_data
