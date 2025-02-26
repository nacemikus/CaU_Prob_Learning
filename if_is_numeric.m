function value = if_is_numeric(x)
    if ischar(x) || isstring(x)
        value = str2double(x);
    elseif isnumeric(x)
        value = x;
    else
        value = NaN; % Optional: handle cases that aren't numeric or strings
    end
end