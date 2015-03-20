class Converter
  def initialize
    @last_node_id = 0
    @from_node_id = nil
    @node_names = {}
    @tree = []
  end

  def branch(node_from,node_to,edge)
    %Q|  #{node_from} -> #{node_to} [label="#{edge}"]|
  end

  def new_node_id
    @last_node_id += 1
    @last_node_id
  end

  def assign_name_to_node(name,node_id)
    @node_names[name] = node_id
  end

  def convert
    STDIN.readlines.each do |line|
      line.strip!
      if (tokens = line.split(' ')).size > 1
        last_id = @last_node_id
        if @from_node_id
          last_id = @from_node_id
          @from_node_id = nil
        end
        new_id = new_node_id
        assign_name_to_node(tokens[1], new_id)
        @tree << branch(last_id, new_id, tokens[0])
      elsif line[0] != '+' && line[0] != '-'
        @from_node_id = @node_names[line]
      else
        last_id = @last_node_id
        if @from_node_id
          last_id = @from_node_id
          @from_node_id = nil
        end
        new_id = new_node_id
        @tree << branch(last_id,new_id,line)
      end
    end

    puts "digraph shogi {"
    puts "  node[fixedsize=true,width=0.5,height=0.5];"
    @tree.each do |t|
      puts t
    end
    puts "}"
  end
end

Converter.new.convert
