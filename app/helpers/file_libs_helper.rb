module FileLibsHelper
  def file_icon(type) 
    icons = {
      Setting.file_libs.doc => "office/word.svg",
      Setting.file_libs.xls => "office/excel.svg",
      Setting.file_libs.pdf => "office/pdf.svg",
      Setting.file_libs.img => "office/image.svg",
      Setting.file_libs.ppt => "office/ppt.svg",
      Setting.file_libs.mp4 => "office/mp4.svg",
      Setting.file_libs.txt => "office/txt.svg"
    }
    icons[type]
  end                                            
end  
