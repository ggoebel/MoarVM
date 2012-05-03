package Config::BuildEnvironment;
use strict;
use warnings;

sub detect {
    my %config;
    
    if ($^O =~ /MSWin32/) {
        # Windows.
        $config{'os'} = 'Windows';
        
        # We support the Microsoft toolchain.
        if (can_run('cl /nologo /?')) {
            # Ensure we have the other bits.
            return (excuse => 'It appears you have the MS C compiler, but no link!')
                unless can_run('link /nologo /?');
            return (excuse => 'It appears you have the MS C compiler, but no nmake!')
                unless can_run('nmake /nologo /?');
            
            # Set configuration flags.
            $config{'cc'}      = 'cl';
            $config{'cflags'}  = '/nologo /Zi -DWIN32';
            $config{'link'}    = 'link';
            $config{'ldflags'} = '/nologo /debug /NODEFAULTLIB kernel32.lib ws2_32.lib msvcrt.lib oldnames.lib advapi32.lib shell32.lib';
            $config{'make'}    = 'nmake';
            $config{'exe'}     = '.exe';
            $config{'o'}       = '.obj';
            $config{'rm'}      = 'del';
        }
        else {
            return (excuse => 'So far, we only building with the Microsoft toolchain on Windows.');
        }
        
        return %config;
    }
    
    return (excuse => 'No recognized operating system or compiler found.');
}

sub can_run {
    my $try = shift;
    return `$try` ne '';
}

'Leffe';
