function PS07_academic_integrity_iLingam(names)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This function prints the academic integrity statements for certain people
% (who's names have been inputed).
%
% Function Call
% PS07_academic_integrity_iLingam(names)
%
% Input Arguments
% names, string array with names
%
% Output Arguments
% No output arguments 
%
% Assignment Information
%   Assignment:       	PS 07, Problem 2
%   Author:             Neel Lingam, ilingam@purdue.edu
%   Team ID:            012-26      
%  	Contributor: 		Name, login@purdue [repeat for each]
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ____________________
%% INITIALIZATION
single = ["I" "am" "my" "I" "I" "my"];  %key words for a singular integrity statement
multiple = ["We" "are" "our" "We" "we" "our"];  %key words for a multi-person integrity statement

%% ____________________
%% SELECTION STRUCTURE
if isstring(names)  %Check if the input is a string
    if numel(names) == 1    %Check if the input is a single name
        printTense = single;    %set the academic integrity statement to singular form
    elseif numel(names) <= 5    %Check if the input is less than 5 names
        printTense = multiple;  %set the academic integrity statement to multi-person form
    else
        error("Number of names does not match an expected value");  %Stop program and tell user that too many names are inputted
    end
else
    error("Names entered are not of type string");  %Stop program and tell user that the input is not strint type
end

% Print the integrity statement and name(s)
fprintf("%s %s submitting code that is %s own original work. %s have not used\nsource code, either modified or unmodified, obtained from any\nunauthorized source. Neither have %s provided access to %s code to any\npeer or unauthorized source. Signed,\n%s\n%s\n%s\n%s\n%s\n", printTense, names);
%% ____________________
%% COMMAND WINDOW OUTPUTS
% PS07_academic_integrity_iLingam(Case1)

% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% Student 1

% PS07_academic_integrity_iLingam(Case2)

% Error using PS07_academic_integrity_iLingam (line 46)
% Names entered are not of type string
%  
% PS07_academic_integrity_iLingam(Case3)

% We are submitting code that is our own original work. We have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have we provided access to our code to any
% peer or unauthorized source. Signed,
% Neel
% Andrew

% PS07_academic_integrity_iLingam(Case4)

% We are submitting code that is our own original work. We have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have we provided access to our code to any
% peer or unauthorized source. Signed,
% Neel
% Andrew
% Nick

% PS07_academic_integrity_iLingam(Case5)

% We are submitting code that is our own original work. We have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have we provided access to our code to any
% peer or unauthorized source. Signed,
% Neel
% Andrew
% Nick
% John

% PS07_academic_integrity_iLingam(Case6)

% We are submitting code that is our own original work. We have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have we provided access to our code to any
% peer or unauthorized source. Signed,
% Neel
% Andrew
% Nick
% John
% Mandy

% PS07_academic_integrity_iLingam(Case7)
% Error using PS07_academic_integrity_iLingam (line 43)
% Number of names does not match an expected value
