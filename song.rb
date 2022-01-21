use_debug false
use_bpm 128
set(:bpm, current_bpm)


live_loop :metro do
  use_bpm get(:bpm)
  sleep 1
end

set_mixer_control! lpf_slide: 30, lpf: 120
set_mixer_control! hpf_slide: 1, hpf: 12

define :c_arp do
  use_synth :sine
  tick
  notes = ring(:c3, :c4, :c5, :c4)
  with_fx :eq, low: -2, high: 3, high_q: 2, mid: -1 do
    with_fx :lpf, cutoff: 80 do
      with_fx :ping_pong, mix: 0.5 do
        play notes.look, amp: 0.5, cutoff: 70
        sleep 0.25
      end
    end
  end
end

define :bass do
  use_synth :saw
  tick
  notas = ring(:c2, :ds2, :d2, :f2)
  with_fx :eq, high: -1, low: -1 do
    with_fx :level, amp: 0.45 do
      with_fx :lpf, cutoff: 60 do
        play notas.look, decay: 3.5, decay_level: 6, sustain: 0.5, amp: 0.3
        sleep 4
      end
    end
  end
end

define :bass_eslik do
  use_synth :sine
  tick
  notis = ring(:c2, :c2, :c3,
               :ds2, :ds2, :c3,
               :d2, :d2, :c3,
               :f2, :f2, :c3)
  slptime = ring(2, 0.5, 1.5)
  play notis.look, amp: 0.7
  sleep slptime.look
end

define :melod do
  use_synth :kalimba
  tick
  notus = ring(:cb7, :bb6, :gb6, :f6,
               :gb6, :bb6, :cb7, :bb6,
               :gb6, :f6, :gb6, :bb6,
               :cb7, :gb6, :f6, :eb6,
               :cb6, :bb5, :f5, :gb5,
               :bb5, :cb6, :bb5, :gb5,
               :f5, :gb5, :bb5, :cb6,
               :bb5, :gb5, :f5, :eb6,)
  with_fx :eq, high: 10, high_note: 10, low: -3, mid: -1 do
    with_fx :hpf, cutoff: 80 do
      play notus.look, amp: 1, release: 0.8
      sleep 1
    end
  end
end

live_loop :melodi, sync: :metro, delay: 36 do
    ##| stop

  use_bpm get(:bpm)
  melod
end

live_loop :arp, sync: :metro do
  ##| stop
  use_bpm get(:bpm)
  c_arp
end

live_loop :bass_line, sync: :metro, delay: 4 do
  ##| stop
  use_bpm get(:bpm)
  with_fx :eq, high: 0, low_note: 5, high_q: 0.1, low: 2 do
    bass
  end
end

live_loop :noihat, sync: :metro, delay: 4 do
  ##| stop
  use_bpm get(:bpm)
  use_synth :cnoise
  with_fx :hpf, cutoff: 120 do
    sleep 0.5
    play :c5, amp: 0.8, release: 0.1, cutoff: 105
    sleep 0.5
  end
end

live_loop :kick, sync: :metro, delay: 4 do
  ##| stop
  use_bpm get(:bpm)
  with_fx :distortion, mix: 0.1 do
    sample :bd_klub, amp: 1.5, release: 0.5
    sleep 1
  end
end

live_loop :bases, sync: :metro, delay: 4 do
  ##| stop
  use_bpm get(:bpm)
  bass_eslik
end

