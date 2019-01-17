function [c, sigmas, goodness] = klorenfit(xdata, ydata, n, initial_guesses, x0_lower_bound, show_fits)
% c = lorentzian_metafits(xdata, ydata, n, initial_guesses, x0_lower_bound, show_fits)
%
% c = lorentzian_metafits(records, [], ...)
%
% fits the same set of lorentzians to multiple data sets.
%
% fits n lorentzians to the records such that each record has lorentzians at the same
%   x0 and of the same width, but of different heights
%
% xdata and ydata are matrices of the same size
%
% show_fits plots the traces and their fits
%
% c is a matrix of lorentzian coefficients; use parse_metafits.
% [x0 w a y0]
%
% CRM 02-08-2006

if nargin < 6, show_fits = 1; end
if nargin < 5, x0_lower_bound = []; end
if nargin < 4, initial_guesses = []; end

n_sets = size(xdata, 2);

all_ydata = ydata(:);
all_xdata = xdata(:);

x_range = max(xdata(:)) - min(xdata(:));
y_range = max(ydata(:)) - min(ydata(:));

% now define the upper and lower bounds for the fit parameters
x0_upper = max(xdata(:)) + x_range;
w_upper = max(x_range, 0.2);
a_upper = 2*y_range;
y0_upper = 0.0000001;% max(min(ydata));

if isempty(x0_lower_bound)
    x0_lower = min(xdata(:)) - .5*x_range;
else
    x0_lower = x0_lower_bound;
end
w_lower = 0;
a_lower = 0;
y0_lower = 0;

% default initial guesses
a = 0.1;
y0 =0; % min(all_ydata) - 0.5*y_range;  % was 0
w = 0.05;

if iscell(initial_guesses)
    x0 = initial_guesses{1};  % n long
    if length(x0) ~= n, error('Wrong number of initial guesses.'); end
    if length(initial_guesses) > 1, w = initial_guesses{2}; end  % n long
    if length(initial_guesses) > 2, a = initial_guesses{3}; end   % n*N long
    if length(initial_guesses) > 3, y0 = initial_guesses{4}; end  % N long

else 
    if isempty(initial_guesses)
        % guess that the peaks are equally distributed across the domain
        x0 = linspace(xdata(1), xdata(end), n + 2);
        x0 = x0(2:end-1);

    elseif (size(initial_guesses, 2) == 4) && (size(initial_guesses,1) > 1)  % initial_guesses is a c matrix
        [x0, w, a, y0] = parse_metafits(initial_guesses, n);

    elseif length(initial_guesses) == n  % only x0 specified
        x0 = min(initial_guesses, x0_upper);
        x0 = max(initial_guesses, x0_lower);
        x0 = initial_guesses(:).';

    else error('Wrong number of initial guesses.');
    end

end

if length(w) == 1, w = repmat(w,1,n); end
if length(a) == 1, a = repmat(a,1,n*n_sets); end
if length(y0) == 1, y0 = repmat(y0,1,n_sets); end

initial_guesses = [x0(:)' w(:)' a(:)' y0(:)'];

% fit to this function:
% y = multiple_lorentzians(x, n_sets, n_lorentzians, set_length, x0, w, a, y0)
equation = sprintf('multiple_lorentzians(x, %g, %g, %s, %s, %s, %s)',...
    n_sets, n, variable_list('x0_', n), variable_list('w_', n), ...
    variable_list('a_', n_sets, n), variable_list('y0_', n_sets));

coefficients_cellstr = [variable_cellstr('x0_', n), variable_cellstr('w_', n), ...
    variable_cellstr('a_', n_sets, n), variable_cellstr('y0_', n_sets)];

upper_bounds = [repmat(x0_upper,1,n) repmat(w_upper,1,n) repmat(a_upper,1,n*n_sets) repmat(y0_upper,1,n_sets)];
lower_bounds = [repmat(x0_lower,1,n) repmat(w_lower,1,n) repmat(a_lower,1,n*n_sets) repmat(y0_lower,1,n_sets)];

if any((initial_guesses < lower_bounds) | (initial_guesses > upper_bounds))
    warning('Some initial guesses are out of bounds! Changing them for you.');
%     [initial_guesses' lower_bounds' upper_bounds']
end

initial_guesses = max(initial_guesses, lower_bounds);
initial_guesses = min(initial_guesses, upper_bounds);

ft_ = fittype(equation ,'dependent',{'y'},'independent',{'x'},'coefficients',coefficients_cellstr);

opts = fitoptions('Method','NonlinearLeastSquares',...
    'Startpoint', initial_guesses, ...
    'MaxFunEvals', 250000, ...       % default is 600
    'MaxIter', 10000, ...
    'Upper', upper_bounds, ...
    'Lower', lower_bounds, ...
    'Display', 'iter');

% Do the fit
[cf_, goodness] = fit(all_xdata, all_ydata, ft_, opts);

answer = coeffvalues(cf_);
limits = confint(cf_, erf(1/sqrt(2)));  % limits for one sigma
% see http://mathworld.wolfram.com/StandardDeviation.html for example

% as far as I can tell, the limits are always symmetric about the value, so I'm condensing
% them into a single number, which I believe is the standard deviation
sigmas = abs(limits(1,:) - answer);

% parse the answer
x0 = answer(1:n); answer(1:n) = [];
w = answer(1:n); answer(1:n) = [];
a = answer(1:n*n_sets); answer(1:n*n_sets) = [];
y0 = answer(1:n_sets); answer(1:n_sets) = [];

x0s = sigmas(1:n); sigmas(1:n) = [];
ws = sigmas(1:n); sigmas(1:n) = [];
as = sigmas(1:n*n_sets); sigmas(1:n*n_sets) = [];
y0s = sigmas(1:n_sets); sigmas(1:n_sets) = [];

% plot if requested
if show_fits
    figure('color','w');
    plot(xdata, ydata,'.', 'MarkerSize',12,'Color',[1/3 0 2/3]); hold on;
    plot(all_xdata, multiple_lorentzians(all_xdata, n_sets, n, x0, w, a, y0),'.r');
    title(sprintf('Fit of %g Lorentzians', n));
    xlabel('Sample Voltage (V)');
    ylabel('dI/dV (a.u.)');

    xlim(sort(xdata([1 end])));
    plot_vertical_lines(x0, ':r');
    drawnow;
    hold off;
end

% create the c matrix, whose rows are lorentzian coefficients [x w a y]
x0 = repmat(x0,[1 n_sets]);
w = repmat(w,[1 n_sets]);
y0 = repmat(y0, [n 1]);
c = [x0(:) w(:) a(:) y0(:)];

x0s = repmat(x0s,[1 n_sets]);
ws = repmat(ws,[1 n_sets]);
y0s = repmat(y0s, [n 1]);
sigmas = [x0s(:) ws(:) as(:) y0s(:)];

function array_cellstr = variable_cellstr(base_string, n, m)
% creates a cellstr variable names
% base_string should be e.g. 'a' or 'x0_'
%
%  examples:  variable_list('a_', 5)
%             [a_1 a_2 a_3 a_4 a_5]
%
%          variable_list('a_', 3, 2)
%          [a_1_1 a_1_2 a_1_3 a_2_1 a_2_2 a_2_3]
%
% this is used by the metafit code
% CRM 2007

array_cellstr = {};
if nargin < 3,
    for j = 1:n, array_cellstr = {array_cellstr{:} [base_string num2str(j)]}; end;
else
    for k = 1:m,
        for j = 1:n,
            array_cellstr = {array_cellstr{:} [base_string num2str(k) '_' num2str(j)]};
        end;
    end;
end

function array_string = variable_list(base_string, n, m)
% creates a string of an array of variables
% base_string should be e.g. 'a' or 'x0_'
%
%  examples:  variable_list('a_', 5)
%             [a_1 a_2 a_3 a_4 a_5]
%
%          variable_list('a_', 3, 2)
%          [a_1_1 a_1_2 a_1_3 a_2_1 a_2_2 a_2_3]
%
% this is used by the metafit code
% CRM 2007

array_string = '[';
if nargin < 3
    for j = 1:n, array_string = [array_string base_string num2str(j) ' ']; end;
else
    for k = 1:m,
        for j = 1:n,
            array_string = [array_string base_string num2str(k) '_' num2str(j) ' '];
        end;
    end;
end;
array_string(end) = ']';
if length(array_string) == 1, array_string = '[]'; end

function varargout = plot_vertical_lines(x, varargin)
% Plots vertical lines at x values specified
%
% h = plot_vertical_lines  returns a handle to the lines
%     plot_vertical_lines(x, linespec) is  supported
%
% To change the lines later or add them to the legend, do
%      set(h, 'handlevisibility', 'on');
%
% CRM 07-20-2006

height = 10^10;

x = x(:);

x_range = get(gca, 'xlim');
y_range = get(gca, 'ylim');

line_x = [x'; x'; NaN*x'];
line_y = [-height*ones(size(x')); height*ones(size(x')); NaN*x'];
% h = line(line_x(:), line_y(:), varargin{:});

hold on;
h = plot(line_x(:), line_y(:), varargin{:});

set(gca, 'ylim', y_range, 'xlim', x_range);

set(h, 'handlevisibility', 'off');

if nargout
    varargout = {h};
end