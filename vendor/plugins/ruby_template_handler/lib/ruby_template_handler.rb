
class RubyTemplateHandler < ActionView::TemplateHandler
  include ActionView::TemplateHandlers::Compilable

  def compile(template)
    src =  'self.output_buffer = (' + template.source + ')'
    unless File.basename(template.filename).starts_with?('_')
      src += '.to_json'
    end
    src
  end
end
