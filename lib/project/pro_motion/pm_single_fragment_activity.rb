# An abstract Activity designed to host a single fragment.
# RM-733
#module ProMotion
  class PMSingleFragmentActivity < PMActivity
    attr_accessor :fragment_container, :fragment

    EXTRA_FRAGMENT_CLASS = "fragment_class"
    EXTRA_FRAGMENT_ARGUMENTS = "fragment_arguments"

    def on_create(saved_instance_state)
      super

      mp "PMSingleFragmentActivity on_create", debugging_only: true

      @fragment_container = Potion::FrameLayout.new(self)
      @fragment_container.setId Potion::ViewIdGenerator.generate
      self.contentView = @fragment_container

      if (fragment_class = intent.getStringExtra(EXTRA_FRAGMENT_CLASS))
        if fragment_instance = Kernel.const_get(fragment_class.to_s).new
          set_fragment fragment_instance

          # Grab the fragment arguments and call them on the class
          if fragment_arguments = intent.getBundleExtra(EXTRA_FRAGMENT_ARGUMENTS)
            fragment_arguments = PMHashBundle.from_bundle(fragment_arguments).to_h

            fragment_arguments.each do |key, value|
              fragment_instance.send "#{key}=", value
            end
          end
        end
      end
    end

    def set_fragment(fragment)
      mp "PMSingleFragmentActivity set_fragment", debugging_only: true
      @fragment = fragment # useful for the REPL
      fragmentManager.beginTransaction.add(@fragment_container.getId, fragment, fragment.class.to_s).commit
    end

  end
#end
