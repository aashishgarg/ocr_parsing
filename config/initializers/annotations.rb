path = File.join(Rails.root, 'shipper_annotations.json')
ANNOTATIONS = File.exist?(path) ? JSON.parse(File.read(path)) : []
