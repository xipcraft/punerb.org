module PuneRuby
  class Test
    def in_event_machine_synchrony_reactor
      EM.synchrony { yield; EM.stop }
    end

    alias_method :in_emr, :in_event_machine_synchrony_reactor
  end
end