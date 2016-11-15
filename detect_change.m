function change_val = detect_change(new_bwimg,old_bwimg,thresh)
%Returns a 0 if <=thresh pixels change between the old and new
%frames.  Returns a 1 if >thresh pixals change to black between the old and
%new frames.  Returns a -1 if >thresh pixels change to white between the old
%and new frames.

    bin_sum_new = sum(sum(new_bwimg));
    bin_sum_old = sum(sum(old_bwimg));
    
    %bit_diff < 0 if new frame has more black than old frame
    %bit_diff > 0 if old frame has more black than new frame
    %bit_diff = 0 if new frame and old frame have the same amount of black
    bit_diff = bin_sum_new-bin_sum_old; 
    if abs(bit_diff) >= thresh
        if bit_diff < 0     %new frame has more black
            change_val = 1;
        end
        if bit_diff > 0     %new frame has more white
            change_val = -1;
        end
    else
        change_val = 0;     %new frame same as old frame
    end
end