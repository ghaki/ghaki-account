############################################################################
module Ghaki
  module Account
    module SynOpts

      #---------------------------------------------------------------------
      def attr_syn_opts token, *syn_list
        klass = self.to_s.split('::').last
        konst = klass.upcase
        module_eval <<-"END"
        
          #{konst}_LIST = syn_list

          def #{klass}.parse_opts opts
            return opts[ :#{token} ] if opts.has_key?( :#{token} )
            #{konst}_LIST.each do |name|
              return opts[name] if opts.has_key?(name)
            end
            return opts[:account].#{token} if opts.has_key?(:account)
            nil
          end

          def #{klass}.purge_opts opts
             opts.delete( :#{token} )
            #{konst}_LIST.each do |name|
              opts.delete(name)
            end
            opts
          end

          def opt_#{token} opts
            val = #{klass}.parse_opts( opts )
            @#{token} = val unless val.nil?
          end

        END
      end

    end # helper
  end # namespace
end # package
############################################################################
