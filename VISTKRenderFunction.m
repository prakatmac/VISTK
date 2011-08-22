function [ output_args ] = VISTKRenderFunction(hFig, plane, varargin)
    parser = inputParser;
    parser.addRequired('hFig', @ishandle);
    parser.addRequired('plane', @(x) ndims(x) == 2 & isnumeric(x));
    parser.addParamValue('ColorRange', [0 255], @(x) numel(x) == 2 & isnumeric(x));
    parser.addParamValue('Slice', 1, @isscalar);
    parser.addParamValue('Projection', 'xy', @ischar);
    parser.addParamValue('FullUpdate', false, @islogical);
    parser.addParamValue('ScaleBar', 0, @isscalar);
    parser.addParamValue('PixelSize', [1 1 1], @(x) isnumeric(x) & numel(x) == 3);
    parser.addParamValue('ColorMap', 'jet', @ischar);
    
    parser.parse(hFig, plane, varargin{:});
    Parameters = parser.Results;
    
    % select the figure
    figure(Parameters.hFig);

    AXES_LABEL_FUN = {@xlabel, @ylabel};
    ALL_AXES = 'xyz';
    
    if(Parameters.FullUpdate)
        clf;
        set(gcf, 'Color', 'white');
        set(gca, 'CLimMode', 'manual');
        set(gca, 'CLim', Parameters.ColorRange);
        colormap(Parameters.ColorMap);
    end


 
    if(Parameters.ScaleBar)
        
    end
    crange = get(gca, 'CLim');
    h = imagesc(plane, crange);
    set(gca, 'YDir', 'normal');

    DA = horzcat( ...
        Parameters.PixelSize(ismember(ALL_AXES, Parameters.Projection)),...
        1);
    set(gca, 'DataAspectRatio', DA);
    set(gca, 'DataAspectRatioMode', 'manual');
    
    % Define current slice axis
    Axis = ALL_AXES(~ismember(ALL_AXES, Parameters.Projection));
    
    title_text = sprintf('%s Projection At %s=%i', ...
        upper(Parameters.Projection), upper(Axis), Parameters.Slice);
    h = title(title_text);
    
    set(h, 'FontName', 'Times New Roman');
    set(h, 'FontSize', 14);
    set(h, 'FontWeight', 'bold');

    for i = 1:numel(Parameters.Projection)
        h = AXES_LABEL_FUN{i}(Parameters.Projection(i));
        set(h, 'FontName', 'Times New Roman');
        set(h, 'FontSize', 12);
    end
end

