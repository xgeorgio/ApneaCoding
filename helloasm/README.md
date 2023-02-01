Title:<br/>
<b>Hello x86: Low-level assembly coding for the 8086 wiring</b>

Description:<br/>
<p>This is a set of four "hello world" codes in x86 assembly, using single-segment 16-bit/i8086 instruction set. The purspose of this tutorial is to demonstrate how exact, minimal-space, yet razor-sharp is assembly coding, especially when dealing with such complexities like the segmented memory model of MS-DOS. 
The four versions are:
<ol>
<li>Hello1.asm: Old-style standard directives, used by '70s-'80s assemblers, for .EXE output.</li>
<li>Hello1C.asm: Old-style standard directives, used by '70s-'80s assemblers, for .COM output.</li>
<li>Hello2.asm: Compact 'dot' directives, used by modern assemblers, for .EXE output.</li>
<li>Hello2C.asm: Compact 'dot' directives, used by modern assemblers, for .COM output.</li>
</ol>
The difference between .EXE and .COM comes from the MS-DOS era, when the first format required 'far' pointers (segment:offset) for memory addresses, while the second fitted everything within a single 64KB segment (code, data, stack). There are specific restrictions to .COM executables regarding calls and data handling, but in very early x86 CPUs they were faster because of the much simpler addressing model. Some linkers had options for producing .COM executables directly, while others required the use of EXE2BIN tool for this image conversion. The memmory map files .MAP are also retainned with the sources .ASM, in order to have a clear view of the layout of each executable image .EXE or .COM (comparison).
