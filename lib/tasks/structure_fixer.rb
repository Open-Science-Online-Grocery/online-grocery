# frozen_string_literal: true

# this class cleans up the changes to structure.sql that reflect the current
# value of autoincrement columns. this information is not needed and creates a
# lot of annoying diffs like this:
#
# -) ENGINE=InnoDB DEFAULT CHARSET=utf8;
# +) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
#
class StructureFixer
  def self.run
    structure_path = Rails.root.join('db/structure.sql')
    structure = File.read(structure_path)
    fixed_structure = structure.gsub(
      /\) ENGINE=InnoDB AUTO_INCREMENT=\d+ DEFAULT CHARSET=/,
      ') ENGINE=InnoDB DEFAULT CHARSET='
    )
    File.write(structure_path, fixed_structure)
  end
end
