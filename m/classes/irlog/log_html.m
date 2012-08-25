%> @brief Log that carries HTML contents
classdef log_html < irlog
    properties
        %> HTML string. Please note that it should contain only things inside the BODY tag. @c html will be "embodied" by embody()
        html;
        %> File name to save to. If left empty, an unexisting filename will be generated when necessary
        filename;
    end;
    methods
        function s = get_embodied(o)
            s = [...
'<html>', 10, ...
'<head>', 10, ...
'<title>', o.classtitle, ' - ', o.title, '</title>', 10, ...
stylesheet(), 10, ...
'<body>', 10, ...
o.html, 10, ...
'</body>', 10, ...
'</html>', 10, ...
];
        end;
        
        %> @return 
        function fn = save(o)
            if isempty(o.filename)
                fn = find_filename('iroothtml', [], 'html');
            else
                fn = o.filename;
            end;
            
            h = fopen(fn, 'w');
            if h <= 0
                irerror(sprintf('Could''t create file "%s"', fn));
            end;
            fwrite(h, o.get_embodied());
            fclose(h);
        end;
        
        function o = open_in_browser(o)
            fn = o.save();
            web(fn, '-new');
        end;
    end;
end