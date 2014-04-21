# The MIT License (MIT)
#
# Copyright (c) 2014 Charlie Barto
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# This software uses the FreeImage open source image library. See http://freeimage.sourceforge.net for details.
#
# FreeImage is used under the FIPL, version 1.0. 


when defined(windows):
  const FreeImageLib = "freeimage.dll"
  when defined(staticlib):
    {.pragma: FreeImageCallconv, cdecl.}
  else:
    {.pragma: FreeImageCallconv, stdcall.}
elif defined(macosx):
  const FreeImageLib = "libfreeimage.dylib"
  {.pragma: FreeImageCallconv, cdecl.}
else:
  const FreeImageLib = "libfreeimage.so"
  {.pragma: FreeImageCallconv, cdecl.}
const 
  FREEIMAGE_MAJOR_VERSION* = 3
  FREEIMAGE_MINOR_VERSION* = 15
  FREEIMAGE_RELEASE_SERIAL* = 4

# Compiler options ---------------------------------------------------------

# This really only affects 24 and 32 bit formats, the rest are always RGB order.

const 
  FREEIMAGE_COLORORDER_BGR* = 0
  FREEIMAGE_COLORORDER_RGB* = 1
  FREEIMAGE_COLORORDER* = FREEIMAGE_COLORORDER_BGR

# For C compatibility --------------------------------------------------------

# Bitmap types -------------------------------------------------------------

type 
  FIBITMAP* = object 
    data*: pointer

  FIMULTIBITMAP* = object 
    data*: pointer


# Types used in the library (directly copied from Windows) -----------------

type 
  BOOL* = int32
  BYTE* = uint8
  WORD* = uint16
  DWORD* = uint32
  LONG* = int32

type 
  RGBQUAD* = object 
    rgbBlue*: BYTE
    rgbGreen*: BYTE
    rgbRed*: BYTE
    rgbReserved*: BYTE

  RGBTRIPLE* = object 
    rgbtBlue*: BYTE
    rgbtGreen*: BYTE
    rgbtRed*: BYTE


type 
  BITMAPINFOHEADER* = object 
    biSize*: DWORD
    biWidth*: LONG
    biHeight*: LONG
    biPlanes*: WORD
    biBitCount*: WORD
    biCompression*: DWORD
    biSizeImage*: DWORD
    biXPelsPerMeter*: LONG
    biYPelsPerMeter*: LONG
    biClrUsed*: DWORD
    biClrImportant*: DWORD

  PBITMAPINFOHEADER* = ptr BITMAPINFOHEADER
  BITMAPINFO* = object 
    bmiHeader*: BITMAPINFOHEADER
    bmiColors*: array[0..1 - 1, RGBQUAD]

  PBITMAPINFO* = ptr BITMAPINFO

# Types used in the library (specific to FreeImage) ------------------------

#* 48-bit RGB 
#

type 
  FIRGB16* = object 
    red*: WORD
    green*: WORD
    blue*: WORD


#* 64-bit RGBA
#

type 
  FIRGBA16* = object 
    red*: WORD
    green*: WORD
    blue*: WORD
    alpha*: WORD


#* 96-bit RGB Float
#

type 
  FIRGBF* = object 
    red*: cfloat
    green*: cfloat
    blue*: cfloat


#* 128-bit RGBA Float
#

type 
  FIRGBAF* = object 
    red*: cfloat
    green*: cfloat
    blue*: cfloat
    alpha*: cfloat


#* Data structure for COMPLEX type (complex number)
#

type 
  FICOMPLEX* = object 
    r*: cdouble
    i*: cdouble


# Indexes for byte arrays, masks and shifts for treating pixels as words ---
# These coincide with the order of RGBQUAD and RGBTRIPLE -------------------

when not(defined(FREEIMAGE_BIGENDIAN)): 
  when FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_BGR: 
    # Little Endian (x86 / MS Windows, Linux) : BGR(A) order
    const 
      FI_RGBA_RED* = 2
      FI_RGBA_GREEN* = 1
      FI_RGBA_BLUE* = 0
      FI_RGBA_ALPHA* = 3
      FI_RGBA_RED_MASK* = 0x00FF0000
      FI_RGBA_GREEN_MASK* = 0x0000FF00
      FI_RGBA_BLUE_MASK* = 0x000000FF
      FI_RGBA_ALPHA_MASK* = 0xFF000000
      FI_RGBA_RED_SHIFT* = 16
      FI_RGBA_GREEN_SHIFT* = 8
      FI_RGBA_BLUE_SHIFT* = 0
      FI_RGBA_ALPHA_SHIFT* = 24
  else: 
    # Little Endian (x86 / MaxOSX) : RGB(A) order
    const 
      FI_RGBA_RED* = 0
      FI_RGBA_GREEN* = 1
      FI_RGBA_BLUE* = 2
      FI_RGBA_ALPHA* = 3
      FI_RGBA_RED_MASK* = 0x000000FF
      FI_RGBA_GREEN_MASK* = 0x0000FF00
      FI_RGBA_BLUE_MASK* = 0x00FF0000
      FI_RGBA_ALPHA_MASK* = 0xFF000000
      FI_RGBA_RED_SHIFT* = 0
      FI_RGBA_GREEN_SHIFT* = 8
      FI_RGBA_BLUE_SHIFT* = 16
      FI_RGBA_ALPHA_SHIFT* = 24
else: 
  when FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_BGR: 
    # Big Endian (PPC / none) : BGR(A) order
    const 
      FI_RGBA_RED* = 2
      FI_RGBA_GREEN* = 1
      FI_RGBA_BLUE* = 0
      FI_RGBA_ALPHA* = 3
      FI_RGBA_RED_MASK* = 0x0000FF00
      FI_RGBA_GREEN_MASK* = 0x00FF0000
      FI_RGBA_BLUE_MASK* = 0xFF000000
      FI_RGBA_ALPHA_MASK* = 0x000000FF
      FI_RGBA_RED_SHIFT* = 8
      FI_RGBA_GREEN_SHIFT* = 16
      FI_RGBA_BLUE_SHIFT* = 24
      FI_RGBA_ALPHA_SHIFT* = 0
  else: 
    # Big Endian (PPC / Linux, MaxOSX) : RGB(A) order
    const 
      FI_RGBA_RED* = 0
      FI_RGBA_GREEN* = 1
      FI_RGBA_BLUE* = 2
      FI_RGBA_ALPHA* = 3
      FI_RGBA_RED_MASK* = 0xFF000000
      FI_RGBA_GREEN_MASK* = 0x00FF0000
      FI_RGBA_BLUE_MASK* = 0x0000FF00
      FI_RGBA_ALPHA_MASK* = 0x000000FF
      FI_RGBA_RED_SHIFT* = 24
      FI_RGBA_GREEN_SHIFT* = 16
      FI_RGBA_BLUE_SHIFT* = 8
      FI_RGBA_ALPHA_SHIFT* = 0
const 
  FI_RGBA_RGB_MASK* = (
    FI_RGBA_RED_MASK or FI_RGBA_GREEN_MASK or FI_RGBA_BLUE_MASK)

# The 16bit macros only include masks and shifts, since each color element is not byte aligned

const 
  FI16_555_RED_MASK* = 0x00007C00
  FI16_555_GREEN_MASK* = 0x000003E0
  FI16_555_BLUE_MASK* = 0x0000001F
  FI16_555_RED_SHIFT* = 10
  FI16_555_GREEN_SHIFT* = 5
  FI16_555_BLUE_SHIFT* = 0
  FI16_565_RED_MASK* = 0x0000F800
  FI16_565_GREEN_MASK* = 0x000007E0
  FI16_565_BLUE_MASK* = 0x0000001F
  FI16_565_RED_SHIFT* = 11
  FI16_565_GREEN_SHIFT* = 5
  FI16_565_BLUE_SHIFT* = 0

# ICC profile support ------------------------------------------------------

const 
  FIICC_DEFAULT* = 0x00000000
  FIICC_COLOR_IS_CMYK* = 0x00000001

type 
  FIICCPROFILE* = object 
    flags*: WORD              # info flag
    size*: DWORD              # profile's size measured in bytes
    data*: pointer            # points to a block of contiguous memory containing the profile
  

# Important enums ----------------------------------------------------------
#* I/O image format identifiers.
#

type 
  FREE_IMAGE_FORMAT* = enum 
    FIF_UNKNOWN = - 1, FIF_BMP = 0, FIF_ICO = 1, FIF_JPEG = 2, FIF_JNG = 3, 
    FIF_KOALA = 4, FIF_LBM = 5, FIF_MNG = 6, FIF_PBM = 7, 
    FIF_PBMRAW = 8, FIF_PCD = 9, FIF_PCX = 10, FIF_PGM = 11, FIF_PGMRAW = 12, 
    FIF_PNG = 13, FIF_PPM = 14, FIF_PPMRAW = 15, FIF_RAS = 16, FIF_TARGA = 17, 
    FIF_TIFF = 18, FIF_WBMP = 19, FIF_PSD = 20, FIF_CUT = 21, FIF_XBM = 22, 
    FIF_XPM = 23, FIF_DDS = 24, FIF_GIF = 25, FIF_HDR = 26, FIF_FAXG3 = 27, 
    FIF_SGI = 28, FIF_EXR = 29, FIF_J2K = 30, FIF_JP2 = 31, FIF_PFM = 32, 
    FIF_PICT = 33, FIF_RAW = 34
const FIF_IFF* = FIF_LBM
#* Image type used in FreeImage.
#

type 
  FREE_IMAGE_TYPE* = enum 
    FIT_UNKNOWN = 0,          # unknown type
    FIT_BITMAP = 1,           # standard image			: 1-, 4-, 8-, 16-, 24-, 32-bit
    FIT_UINT16 = 2,           # array of unsigned short	: unsigned 16-bit
    FIT_INT16 = 3,            # array of short			: signed 16-bit
    FIT_UINT32 = 4,           # array of unsigned long	: unsigned 32-bit
    FIT_INT32 = 5,            # array of long			: signed 32-bit
    FIT_FLOAT = 6,            # array of float			: 32-bit IEEE floating point
    FIT_DOUBLE = 7,           # array of double			: 64-bit IEEE floating point
    FIT_COMPLEX = 8,          # array of FICOMPLEX		: 2 x 64-bit IEEE floating point
    FIT_RGB16 = 9,            # 48-bit RGB image			: 3 x 16-bit
    FIT_RGBA16 = 10,          # 64-bit RGBA image		: 4 x 16-bit
    FIT_RGBF = 11,            # 96-bit RGB float image	: 3 x 32-bit IEEE floating point
    FIT_RGBAF = 12

#* Image color type used in FreeImage.
#

type 
  FREE_IMAGE_COLOR_TYPE* = enum 
    FIC_MINISWHITE = 0,       # min value is white
    FIC_MINISBLACK = 1,       # min value is black
    FIC_RGB = 2,              # RGB color model
    FIC_PALETTE = 3,          # color map indexed
    FIC_RGBALPHA = 4,         # RGB color model with alpha channel
    FIC_CMYK = 5

#* Color quantization algorithms.
#Constants used in FreeImage_ColorQuantize.
#

type 
  FREE_IMAGE_QUANTIZE* = enum 
    FIQ_WUQUANT = 0,          # Xiaolin Wu color quantization algorithm
    FIQ_NNQUANT = 1

#* Dithering algorithms.
#Constants used in FreeImage_Dither.
#

type 
  eFREE_IMAGE_DITHER* = enum 
    FID_FS = 0,               # Floyd & Steinberg error diffusion
    FID_BAYER4x4 = 1,         # Bayer ordered dispersed dot dithering (order 2 dithering matrix)
    FID_BAYER8x8 = 2,         # Bayer ordered dispersed dot dithering (order 3 dithering matrix)
    FID_CLUSTER6x6 = 3,       # Ordered clustered dot dithering (order 3 - 6x6 matrix)
    FID_CLUSTER8x8 = 4,       # Ordered clustered dot dithering (order 4 - 8x8 matrix)
    FID_CLUSTER16x16 = 5,     # Ordered clustered dot dithering (order 8 - 16x16 matrix)
    FID_BAYER16x16 = 6

#* Lossless JPEG transformations
#Constants used in FreeImage_JPEGTransform
#

type 
  FREE_IMAGE_JPEG_OPERATION* = enum 
    FIJPEG_OP_NONE = 0,       # no transformation
    FIJPEG_OP_FLIP_H = 1,     # horizontal flip
    FIJPEG_OP_FLIP_V = 2,     # vertical flip
    FIJPEG_OP_TRANSPOSE = 3,  # transpose across UL-to-LR axis
    FIJPEG_OP_TRANSVERSE = 4, # transpose across UR-to-LL axis
    FIJPEG_OP_ROTATE_90 = 5,  # 90-degree clockwise rotation
    FIJPEG_OP_ROTATE_180 = 6, # 180-degree rotation
    FIJPEG_OP_ROTATE_270 = 7

#* Tone mapping operators.
#Constants used in FreeImage_ToneMapping.
#

type 
  FREE_IMAGE_TMO* = enum 
    FITMO_DRAGO03 = 0,        # Adaptive logarithmic mapping (F. Drago, 2003)
    FITMO_REINHARD05 = 1,     # Dynamic range reduction inspired by photoreceptor physiology (E. Reinhard, 2005)
    FITMO_FATTAL02 = 2

#* Upsampling / downsampling filters. 
#Constants used in FreeImage_Rescale.
#

type 
  FREE_IMAGE_FILTER* = enum 
    FILTER_BOX = 0,           # Box, pulse, Fourier window, 1st order (constant) b-spline
    FILTER_BICUBIC = 1,       # Mitchell & Netravali's two-param cubic filter
    FILTER_BILINEAR = 2,      # Bilinear filter
    FILTER_BSPLINE = 3,       # 4th order (cubic) b-spline
    FILTER_CATMULLROM = 4,    # Catmull-Rom spline, Overhauser spline
    FILTER_LANCZOS3 = 5

#* Color channels.
#Constants used in color manipulation routines.
#

type 
  FREE_IMAGE_COLOR_CHANNEL* = enum 
    FICC_RGB = 0,             # Use red, green and blue channels
    FICC_RED = 1,             # Use red channel
    FICC_GREEN = 2,           # Use green channel
    FICC_BLUE = 3,            # Use blue channel
    FICC_ALPHA = 4,           # Use alpha channel
    FICC_BLACK = 5,           # Use black channel
    FICC_REAL = 6,            # Complex images: use real part
    FICC_IMAG = 7,            # Complex images: use imaginary part
    FICC_MAG = 8,             # Complex images: use magnitude
    FICC_PHASE = 9

# Metadata support ---------------------------------------------------------
#*
#  Tag data type information (based on TIFF specifications)
#
#  Note: RATIONALs are the ratio of two 32-bit integer values.
#

type 
  FREE_IMAGE_MDTYPE* = enum 
    FIDT_NOTYPE = 0,          # placeholder 
    FIDT_BYTE = 1,            # 8-bit unsigned integer 
    FIDT_ASCII = 2,           # 8-bit bytes w/ last byte null 
    FIDT_SHORT = 3,           # 16-bit unsigned integer 
    FIDT_LONG = 4,            # 32-bit unsigned integer 
    FIDT_RATIONAL = 5,        # 64-bit unsigned fraction 
    FIDT_SBYTE = 6,           # 8-bit signed integer 
    FIDT_UNDEFINED = 7,       # 8-bit untyped data 
    FIDT_SSHORT = 8,          # 16-bit signed integer 
    FIDT_SLONG = 9,           # 32-bit signed integer 
    FIDT_SRATIONAL = 10,      # 64-bit signed fraction 
    FIDT_FLOAT = 11,          # 32-bit IEEE floating point 
    FIDT_DOUBLE = 12,         # 64-bit IEEE floating point 
    FIDT_IFD = 13,            # 32-bit unsigned integer (offset) 
    FIDT_PALETTE = 14,        # 32-bit RGBQUAD 
    FIDT_LONG8 = 16,          # 64-bit unsigned integer 
    FIDT_SLONG8 = 17,         # 64-bit signed integer
    FIDT_IFD8 = 18

#*
#  Metadata models supported by FreeImage
#

type 
  FREE_IMAGE_MDMODEL* = enum 
    FIMD_NODATA = - 1, FIMD_COMMENTS = 0, # single comment or keywords
    FIMD_EXIF_MAIN = 1,       # Exif-TIFF metadata
    FIMD_EXIF_EXIF = 2,       # Exif-specific metadata
    FIMD_EXIF_GPS = 3,        # Exif GPS metadata
    FIMD_EXIF_MAKERNOTE = 4,  # Exif maker note metadata
    FIMD_EXIF_INTEROP = 5,    # Exif interoperability metadata
    FIMD_IPTC = 6,            # IPTC/NAA metadata
    FIMD_XMP = 7,             # Abobe XMP metadata
    FIMD_GEOTIFF = 8,         # GeoTIFF metadata
    FIMD_ANIMATION = 9,       # Animation metadata
    FIMD_CUSTOM = 10,         # Used to attach other metadata types to a dib
    FIMD_EXIF_RAW = 11

#*
#  Handle to a metadata model
#

type 
  FIMETADATA* = object 
    data*: pointer


#*
#  Handle to a FreeImage tag
#

type 
  FITAG* = object 
    data*: pointer


# File IO routines ---------------------------------------------------------

when not(defined(FREEIMAGE_IO)): 
  const 
    cFREEIMAGE_IO* = true
  type 
    fi_handle* = pointer
    FI_ReadProc* = proc (buffer: pointer; size: cuint; count: cuint; 
                         handle: fi_handle): cuint {.FreeImageCallconv.}
    FI_WriteProc* = proc (buffer: pointer; size: cuint; count: cuint; 
                          handle: fi_handle): cuint {.FreeImageCallconv.}
    FI_SeekProc* = proc (handle: fi_handle; offset: clong; origin: cint): cint {.FreeImageCallconv.}
    FI_TellProc* = proc (handle: fi_handle): clong {.FreeImageCallconv.}
  type 
    FreeImageIO* = object 
      read_proc*: FI_ReadProc # pointer to the function used to read data
      write_proc*: FI_WriteProc # pointer to the function used to write data
      seek_proc*: FI_SeekProc # pointer to the function used to seek
      tell_proc*: FI_TellProc # pointer to the function used to aquire the current position
    
  #*
  #Handle to a memory I/O stream
  #
  type 
    FIMEMORY* = object 
      data*: pointer

# Plugin routines ----------------------------------------------------------

when not(defined(PLUGINS)): 
  const 
    PLUGINS* = true
  type 
    FI_FormatProc* = proc (): cstring
    FI_DescriptionProc* = proc (): cstring
    FI_ExtensionListProc* = proc (): cstring
    FI_RegExprProc* = proc (): cstring
    FI_OpenProc* = proc (io: ptr FreeImageIO; handle: fi_handle; read: BOOL): pointer
    FI_CloseProc* = proc (io: ptr FreeImageIO; handle: fi_handle; data: pointer)
    FI_PageCountProc* = proc (io: ptr FreeImageIO; handle: fi_handle; 
                              data: pointer): cint
    FI_PageCapabilityProc* = proc (io: ptr FreeImageIO; handle: fi_handle; 
                                   data: pointer): cint
    FI_LoadProc* = proc (io: ptr FreeImageIO; handle: fi_handle; page: cint; 
                         flags: cint; data: pointer): ptr FIBITMAP
    FI_SaveProc* = proc (io: ptr FreeImageIO; dib: ptr FIBITMAP; 
                         handle: fi_handle; page: cint; flags: cint; 
                         data: pointer): BOOL
    FI_ValidateProc* = proc (io: ptr FreeImageIO; handle: fi_handle): BOOL
    FI_MimeProc* = proc (): cstring
    FI_SupportsExportBPPProc* = proc (bpp: cint): BOOL
    FI_SupportsExportTypeProc* = proc (typen: FREE_IMAGE_TYPE): BOOL
    FI_SupportsICCProfilesProc* = proc (): BOOL
    FI_SupportsNoPixelsProc* = proc (): BOOL
    Plugin* = object 
      format_proc*: FI_FormatProc
      description_proc*: FI_DescriptionProc
      extension_proc*: FI_ExtensionListProc
      regexpr_proc*: FI_RegExprProc
      open_proc*: FI_OpenProc
      close_proc*: FI_CloseProc
      pagecount_proc*: FI_PageCountProc
      pagecapability_proc*: FI_PageCapabilityProc
      load_proc*: FI_LoadProc
      save_proc*: FI_SaveProc
      validate_proc*: FI_ValidateProc
      mime_proc*: FI_MimeProc
      supports_export_bpp_proc*: FI_SupportsExportBPPProc
      supports_export_type_proc*: FI_SupportsExportTypeProc
      supports_icc_profiles_proc*: FI_SupportsICCProfilesProc
      supports_no_pixels_proc*: FI_SupportsNoPixelsProc

    FI_InitProc* = proc (plugin: ptr Plugin; format_id: cint)
# Load / Save flag constants -----------------------------------------------

const 
  FIF_LOAD_NOPIXELS* = 0x00008000
  BMP_DEFAULT* = 0
  BMP_SAVE_RLE* = 1
  CUT_DEFAULT* = 0
  DDS_DEFAULT* = 0
  EXR_DEFAULT* = 0
  EXR_FLOAT* = 0x00000001
  EXR_NONE* = 0x00000002
  EXR_ZIP* = 0x00000004
  EXR_PIZ* = 0x00000008
  EXR_PXR24* = 0x00000010
  EXR_B44* = 0x00000020
  EXR_LC* = 0x00000040
  FAXG3_DEFAULT* = 0
  GIF_DEFAULT* = 0
  GIF_LOAD256* = 1
  GIF_PLAYBACK* = 2
  HDR_DEFAULT* = 0
  ICO_DEFAULT* = 0
  ICO_MAKEALPHA* = 1
  IFF_DEFAULT* = 0
  J2K_DEFAULT* = 0
  JP2_DEFAULT* = 0
  JPEG_DEFAULT* = 0
  JPEG_FAST* = 0x00000001
  JPEG_ACCURATE* = 0x00000002
  JPEG_CMYK* = 0x00000004
  JPEG_EXIFROTATE* = 0x00000008
  JPEG_GREYSCALE* = 0x00000010
  JPEG_QUALITYSUPERB* = 0x00000080
  JPEG_QUALITYGOOD* = 0x00000100
  JPEG_QUALITYNORMAL* = 0x00000200
  JPEG_QUALITYAVERAGE* = 0x00000400
  JPEG_QUALITYBAD* = 0x00000800
  JPEG_PROGRESSIVE* = 0x00002000
  JPEG_SUBSAMPLING_411* = 0x00001000
  JPEG_SUBSAMPLING_420* = 0x00004000
  JPEG_SUBSAMPLING_422* = 0x00008000
  JPEG_SUBSAMPLING_444* = 0x00010000
  JPEG_OPTIMIZE* = 0x00020000
  JPEG_BASELINE* = 0x00040000
  KOALA_DEFAULT* = 0
  LBM_DEFAULT* = 0
  MNG_DEFAULT* = 0
  PCD_DEFAULT* = 0
  PCD_BASE* = 1
  PCD_BASEDIV4* = 2
  PCD_BASEDIV16* = 3
  PCX_DEFAULT* = 0
  PFM_DEFAULT* = 0
  PICT_DEFAULT* = 0
  PNG_DEFAULT* = 0
  PNG_IGNOREGAMMA* = 1
  PNG_Z_BEST_SPEED* = 0x00000001
  PNG_Z_DEFAULT_COMPRESSION* = 0x00000006
  PNG_Z_BEST_COMPRESSION* = 0x00000009
  PNG_Z_NO_COMPRESSION* = 0x00000100
  PNG_INTERLACED* = 0x00000200
  PNM_DEFAULT* = 0
  PNM_SAVE_RAW* = 0
  PNM_SAVE_ASCII* = 1
  PSD_DEFAULT* = 0
  PSD_CMYK* = 1
  PSD_LAB* = 2
  RAS_DEFAULT* = 0
  RAW_DEFAULT* = 0
  RAW_PREVIEW* = 1
  RAW_DISPLAY* = 2
  RAW_HALFSIZE* = 4
  SGI_DEFAULT* = 0
  TARGA_DEFAULT* = 0
  TARGA_LOAD_RGB888* = 1
  TARGA_SAVE_RLE* = 2
  TIFF_DEFAULT* = 0
  TIFF_CMYK* = 0x00000001
  TIFF_PACKBITS* = 0x00000100
  TIFF_DEFLATE* = 0x00000200
  TIFF_ADOBE_DEFLATE* = 0x00000400
  TIFF_NONE* = 0x00000800
  TIFF_CCITTFAX3* = 0x00001000
  TIFF_CCITTFAX4* = 0x00002000
  TIFF_LZW* = 0x00004000
  TIFF_JPEG* = 0x00008000
  TIFF_LOGLUV* = 0x00010000
  WBMP_DEFAULT* = 0
  XBM_DEFAULT* = 0
  XPM_DEFAULT* = 0

# Background filling options ---------------------------------------------------------
# Constants used in FreeImage_FillBackground and FreeImage_EnlargeCanvas

const 
  FI_COLOR_IS_RGB_COLOR* = 0x00000000
  FI_COLOR_IS_RGBA_COLOR* = 0x00000001
  FI_COLOR_FIND_EQUAL_COLOR* = 0x00000002
  FI_COLOR_ALPHA_IS_INDEX* = 0x00000004
  FI_COLOR_PALETTE_SEARCH_MASK* = (
    FI_COLOR_FIND_EQUAL_COLOR or FI_COLOR_ALPHA_IS_INDEX) # No color lookup is performed

when defined(windows):
  {.push callconv: stdcall.}
else:
  {.push callconv: cdecl.}
# Init / Error routines ----------------------------------------------------

proc FreeImage_Initialise*(load_local_plugins_only: BOOL) {.
    importc: "FreeImage_Initialise", dynlib: FreeImageLib.}
proc FreeImage_DeInitialise*() {.importc: "FreeImage_DeInitialise", 
                                 dynlib: FreeImageLib.}
# Version routines ---------------------------------------------------------

proc FreeImage_GetVersion*(): cstring {.importc: "FreeImage_GetVersion", 
                                        dynlib: FreeImageLib.}
proc FreeImage_GetCopyrightMessage*(): cstring {.
    importc: "FreeImage_GetCopyrightMessage", dynlib: FreeImageLib.}
# Message output functions -------------------------------------------------

type 
  FreeImage_OutputMessageFunction* = proc (fif: FREE_IMAGE_FORMAT; msg: cstring)
  FreeImage_OutputMessageFunctionStdCall* = proc (fif: FREE_IMAGE_FORMAT; 
      msg: cstring)

proc FreeImage_SetOutputMessageStdCall*(omf: FreeImage_OutputMessageFunctionStdCall) {.
    importc: "FreeImage_SetOutputMessageStdCall", dynlib: FreeImageLib.}
proc FreeImage_SetOutputMessage*(omf: FreeImage_OutputMessageFunction) {.
    importc: "FreeImage_SetOutputMessage", dynlib: FreeImageLib.}
proc FreeImage_OutputMessageProc*(fif: cint; fmt: cstring) {.varargs, 
    importc: "FreeImage_OutputMessageProc", dynlib: FreeImageLib.}
# Allocate / Clone / Unload routines ---------------------------------------

proc FreeImage_Allocate*(width: cint; height: cint; bpp: cint; red_mask: cuint; 
                         green_mask: cuint; blue_mask: cuint): ptr FIBITMAP {.
    importc: "FreeImage_Allocate", dynlib: FreeImageLib.}
proc FreeImage_AllocateT*(typen: FREE_IMAGE_TYPE; width: cint; height: cint; 
                          bpp: cint; red_mask: cuint; green_mask: cuint; 
                          blue_mask: cuint): ptr FIBITMAP {.
    importc: "FreeImage_AllocateT", dynlib: FreeImageLib.}
proc FreeImage_Clone*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_Clone", dynlib: FreeImageLib.}
proc FreeImage_Unload*(dib: ptr FIBITMAP) {.importc: "FreeImage_Unload", 
    dynlib: FreeImageLib.}
# Header loading routines

proc FreeImage_HasPixels*(dib: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_HasPixels", dynlib: FreeImageLib.}
# Load / Save routines -----------------------------------------------------

proc FreeImage_Load*(fif: FREE_IMAGE_FORMAT; filename: cstring; flags: cint): ptr FIBITMAP {.
    importc: "FreeImage_Load", dynlib: FreeImageLib.}
proc FreeImage_LoadU*(fif: FREE_IMAGE_FORMAT; filename: ptr uint16; flags: cint): ptr FIBITMAP {.
    importc: "FreeImage_LoadU", dynlib: FreeImageLib.}
proc FreeImage_LoadFromHandle*(fif: FREE_IMAGE_FORMAT; io: ptr FreeImageIO; 
                               handle: fi_handle; flags: cint): ptr FIBITMAP {.
    importc: "FreeImage_LoadFromHandle", dynlib: FreeImageLib.}
proc FreeImage_Save*(fif: FREE_IMAGE_FORMAT; dib: ptr FIBITMAP; 
                     filename: cstring; flags: cint): BOOL {.
    importc: "FreeImage_Save", dynlib: FreeImageLib.}
proc FreeImage_SaveU*(fif: FREE_IMAGE_FORMAT; dib: ptr FIBITMAP; 
                      filename: ptr uint16; flags: cint): BOOL {.
    importc: "FreeImage_SaveU", dynlib: FreeImageLib.}
proc FreeImage_SaveToHandle*(fif: FREE_IMAGE_FORMAT; dib: ptr FIBITMAP; 
                             io: ptr FreeImageIO; handle: fi_handle; flags: cint): BOOL {.
    importc: "FreeImage_SaveToHandle", dynlib: FreeImageLib.}
# Memory I/O stream routines -----------------------------------------------

proc FreeImage_OpenMemory*(data: ptr BYTE; size_in_bytes: DWORD): ptr FIMEMORY {.
    importc: "FreeImage_OpenMemory", dynlib: FreeImageLib.}
proc FreeImage_CloseMemory*(stream: ptr FIMEMORY) {.
    importc: "FreeImage_CloseMemory", dynlib: FreeImageLib.}
proc FreeImage_LoadFromMemory*(fif: FREE_IMAGE_FORMAT; stream: ptr FIMEMORY; 
                               flags: cint): ptr FIBITMAP {.
    importc: "FreeImage_LoadFromMemory", dynlib: FreeImageLib.}
proc FreeImage_SaveToMemory*(fif: FREE_IMAGE_FORMAT; dib: ptr FIBITMAP; 
                             stream: ptr FIMEMORY; flags: cint): BOOL {.
    importc: "FreeImage_SaveToMemory", dynlib: FreeImageLib.}
proc FreeImage_TellMemory*(stream: ptr FIMEMORY): clong {.
    importc: "FreeImage_TellMemory", dynlib: FreeImageLib.}
proc FreeImage_SeekMemory*(stream: ptr FIMEMORY; offset: clong; origin: cint): BOOL {.
    importc: "FreeImage_SeekMemory", dynlib: FreeImageLib.}
proc FreeImage_AcquireMemory*(stream: ptr FIMEMORY; data: ptr ptr BYTE; 
                              size_in_bytes: ptr DWORD): BOOL {.
    importc: "FreeImage_AcquireMemory", dynlib: FreeImageLib.}
proc FreeImage_ReadMemory*(buffer: pointer; size: cuint; count: cuint; 
                           stream: ptr FIMEMORY): cuint {.
    importc: "FreeImage_ReadMemory", dynlib: FreeImageLib.}
proc FreeImage_WriteMemory*(buffer: pointer; size: cuint; count: cuint; 
                            stream: ptr FIMEMORY): cuint {.
    importc: "FreeImage_WriteMemory", dynlib: FreeImageLib.}
proc FreeImage_LoadMultiBitmapFromMemory*(fif: FREE_IMAGE_FORMAT; 
    stream: ptr FIMEMORY; flags: cint): ptr FIMULTIBITMAP {.
    importc: "FreeImage_LoadMultiBitmapFromMemory", dynlib: FreeImageLib.}
proc FreeImage_SaveMultiBitmapToMemory*(fif: FREE_IMAGE_FORMAT; 
                                        bitmap: ptr FIMULTIBITMAP; 
                                        stream: ptr FIMEMORY; flags: cint): BOOL {.
    importc: "FreeImage_SaveMultiBitmapToMemory", dynlib: FreeImageLib.}
# Plugin Interface ---------------------------------------------------------

proc FreeImage_RegisterLocalPlugin*(proc_address: FI_InitProc; format: cstring; 
                                    description: cstring; extension: cstring; 
                                    regexpr: cstring): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_RegisterLocalPlugin", dynlib: FreeImageLib.}
#the FreeImage_RegisterLocalPlugin function is not actually exported on my system
#so we are not going to import it
discard """
proc FreeImage_RegisterExternalPlugin*(path: cstring; format: cstring; 
                                       description: cstring; extension: cstring; 
                                       regexpr: cstring): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_RegisterExternalPlugin", dynlib: FreeImageLib.}
"""
proc FreeImage_GetFIFCount*(): cint {.importc: "FreeImage_GetFIFCount", 
                                      dynlib: FreeImageLib.}
proc FreeImage_SetPluginEnabled*(fif: FREE_IMAGE_FORMAT; enable: BOOL): cint {.
    importc: "FreeImage_SetPluginEnabled", dynlib: FreeImageLib.}
proc FreeImage_IsPluginEnabled*(fif: FREE_IMAGE_FORMAT): cint {.
    importc: "FreeImage_IsPluginEnabled", dynlib: FreeImageLib.}
proc FreeImage_GetFIFFromFormat*(format: cstring): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFIFFromFormat", dynlib: FreeImageLib.}
proc FreeImage_GetFIFFromMime*(mime: cstring): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFIFFromMime", dynlib: FreeImageLib.}
proc FreeImage_GetFormatFromFIF*(fif: FREE_IMAGE_FORMAT): cstring {.
    importc: "FreeImage_GetFormatFromFIF", dynlib: FreeImageLib.}
proc FreeImage_GetFIFExtensionList*(fif: FREE_IMAGE_FORMAT): cstring {.
    importc: "FreeImage_GetFIFExtensionList", dynlib: FreeImageLib.}
proc FreeImage_GetFIFDescription*(fif: FREE_IMAGE_FORMAT): cstring {.
    importc: "FreeImage_GetFIFDescription", dynlib: FreeImageLib.}
proc FreeImage_GetFIFRegExpr*(fif: FREE_IMAGE_FORMAT): cstring {.
    importc: "FreeImage_GetFIFRegExpr", dynlib: FreeImageLib.}
proc FreeImage_GetFIFMimeType*(fif: FREE_IMAGE_FORMAT): cstring {.
    importc: "FreeImage_GetFIFMimeType", dynlib: FreeImageLib.}
proc FreeImage_GetFIFFromFilename*(filename: cstring): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFIFFromFilename", dynlib: FreeImageLib.}
proc FreeImage_GetFIFFromFilenameU*(filename: ptr uint16): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFIFFromFilenameU", dynlib: FreeImageLib.}
proc FreeImage_FIFSupportsReading*(fif: FREE_IMAGE_FORMAT): BOOL {.
    importc: "FreeImage_FIFSupportsReading", dynlib: FreeImageLib.}
proc FreeImage_FIFSupportsWriting*(fif: FREE_IMAGE_FORMAT): BOOL {.
    importc: "FreeImage_FIFSupportsWriting", dynlib: FreeImageLib.}
proc FreeImage_FIFSupportsExportBPP*(fif: FREE_IMAGE_FORMAT; bpp: cint): BOOL {.
    importc: "FreeImage_FIFSupportsExportBPP", dynlib: FreeImageLib.}
proc FreeImage_FIFSupportsExportType*(fif: FREE_IMAGE_FORMAT; 
                                      typen: FREE_IMAGE_TYPE): BOOL {.
    importc: "FreeImage_FIFSupportsExportType", dynlib: FreeImageLib.}
proc FreeImage_FIFSupportsICCProfiles*(fif: FREE_IMAGE_FORMAT): BOOL {.
    importc: "FreeImage_FIFSupportsICCProfiles", dynlib: FreeImageLib.}
proc FreeImage_FIFSupportsNoPixels*(fif: FREE_IMAGE_FORMAT): BOOL {.
    importc: "FreeImage_FIFSupportsNoPixels", dynlib: FreeImageLib.}
# Multipaging interface ----------------------------------------------------

proc FreeImage_OpenMultiBitmap*(fif: FREE_IMAGE_FORMAT; filename: cstring; 
                                create_new: BOOL; read_only: BOOL; 
                                keep_cache_in_memory: BOOL; flags: cint): ptr FIMULTIBITMAP {.
    importc: "FreeImage_OpenMultiBitmap", dynlib: FreeImageLib.}
proc FreeImage_OpenMultiBitmapFromHandle*(fif: FREE_IMAGE_FORMAT; 
    io: ptr FreeImageIO; handle: fi_handle; flags: cint): ptr FIMULTIBITMAP {.
    importc: "FreeImage_OpenMultiBitmapFromHandle", dynlib: FreeImageLib.}
proc FreeImage_SaveMultiBitmapToHandle*(fif: FREE_IMAGE_FORMAT; 
                                        bitmap: ptr FIMULTIBITMAP; 
                                        io: ptr FreeImageIO; handle: fi_handle; 
                                        flags: cint): BOOL {.
    importc: "FreeImage_SaveMultiBitmapToHandle", dynlib: FreeImageLib.}
proc FreeImage_CloseMultiBitmap*(bitmap: ptr FIMULTIBITMAP; flags: cint): BOOL {.
    importc: "FreeImage_CloseMultiBitmap", dynlib: FreeImageLib.}
proc FreeImage_GetPageCount*(bitmap: ptr FIMULTIBITMAP): cint {.
    importc: "FreeImage_GetPageCount", dynlib: FreeImageLib.}
proc FreeImage_AppendPage*(bitmap: ptr FIMULTIBITMAP; data: ptr FIBITMAP) {.
    importc: "FreeImage_AppendPage", dynlib: FreeImageLib.}
proc FreeImage_InsertPage*(bitmap: ptr FIMULTIBITMAP; page: cint; 
                           data: ptr FIBITMAP) {.
    importc: "FreeImage_InsertPage", dynlib: FreeImageLib.}
proc FreeImage_DeletePage*(bitmap: ptr FIMULTIBITMAP; page: cint) {.
    importc: "FreeImage_DeletePage", dynlib: FreeImageLib.}
proc FreeImage_LockPage*(bitmap: ptr FIMULTIBITMAP; page: cint): ptr FIBITMAP {.
    importc: "FreeImage_LockPage", dynlib: FreeImageLib.}
proc FreeImage_UnlockPage*(bitmap: ptr FIMULTIBITMAP; data: ptr FIBITMAP; 
                           changed: BOOL) {.importc: "FreeImage_UnlockPage", 
    dynlib: FreeImageLib.}
proc FreeImage_MovePage*(bitmap: ptr FIMULTIBITMAP; target: cint; source: cint): BOOL {.
    importc: "FreeImage_MovePage", dynlib: FreeImageLib.}
proc FreeImage_GetLockedPageNumbers*(bitmap: ptr FIMULTIBITMAP; pages: ptr cint; 
                                     count: ptr cint): BOOL {.
    importc: "FreeImage_GetLockedPageNumbers", dynlib: FreeImageLib.}
# Filetype request routines ------------------------------------------------

proc FreeImage_GetFileType*(filename: cstring; size: cint): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFileType", dynlib: FreeImageLib.}
proc FreeImage_GetFileTypeU*(filename: ptr uint16; size: cint): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFileTypeU", dynlib: FreeImageLib.}
proc FreeImage_GetFileTypeFromHandle*(io: ptr FreeImageIO; handle: fi_handle; 
                                      size: cint): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFileTypeFromHandle", dynlib: FreeImageLib.}
proc FreeImage_GetFileTypeFromMemory*(stream: ptr FIMEMORY; size: cint): FREE_IMAGE_FORMAT {.
    importc: "FreeImage_GetFileTypeFromMemory", dynlib: FreeImageLib.}
# Image type request routine -----------------------------------------------

proc FreeImage_GetImageType*(dib: ptr FIBITMAP): FREE_IMAGE_TYPE {.
    importc: "FreeImage_GetImageType", dynlib: FreeImageLib.}
# FreeImage helper routines ------------------------------------------------

proc FreeImage_IsLittleEndian*(): BOOL {.importc: "FreeImage_IsLittleEndian", 
    dynlib: FreeImageLib.}
proc FreeImage_LookupX11Color*(szColor: cstring; nRed: ptr BYTE; 
                               nGreen: ptr BYTE; nBlue: ptr BYTE): BOOL {.
    importc: "FreeImage_LookupX11Color", dynlib: FreeImageLib.}
proc FreeImage_LookupSVGColor*(szColor: cstring; nRed: ptr BYTE; 
                               nGreen: ptr BYTE; nBlue: ptr BYTE): BOOL {.
    importc: "FreeImage_LookupSVGColor", dynlib: FreeImageLib.}
# Pixel access routines ----------------------------------------------------

proc FreeImage_GetBits*(dib: ptr FIBITMAP): ptr BYTE {.
    importc: "FreeImage_GetBits", dynlib: FreeImageLib.}
proc FreeImage_GetScanLine*(dib: ptr FIBITMAP; scanline: cint): ptr BYTE {.
    importc: "FreeImage_GetScanLine", dynlib: FreeImageLib.}
proc FreeImage_GetPixelIndex*(dib: ptr FIBITMAP; x: cuint; y: cuint; 
                              value: ptr BYTE): BOOL {.
    importc: "FreeImage_GetPixelIndex", dynlib: FreeImageLib.}
proc FreeImage_GetPixelColor*(dib: ptr FIBITMAP; x: cuint; y: cuint; 
                              value: ptr RGBQUAD): BOOL {.
    importc: "FreeImage_GetPixelColor", dynlib: FreeImageLib.}
proc FreeImage_SetPixelIndex*(dib: ptr FIBITMAP; x: cuint; y: cuint; 
                              value: ptr BYTE): BOOL {.
    importc: "FreeImage_SetPixelIndex", dynlib: FreeImageLib.}
proc FreeImage_SetPixelColor*(dib: ptr FIBITMAP; x: cuint; y: cuint; 
                              value: ptr RGBQUAD): BOOL {.
    importc: "FreeImage_SetPixelColor", dynlib: FreeImageLib.}
# DIB info routines --------------------------------------------------------

proc FreeImage_GetColorsUsed*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetColorsUsed", dynlib: FreeImageLib.}
proc FreeImage_GetBPP*(dib: ptr FIBITMAP): cuint {.importc: "FreeImage_GetBPP", 
    dynlib: FreeImageLib.}
proc FreeImage_GetWidth*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetWidth", dynlib: FreeImageLib.}
proc FreeImage_GetHeight*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetHeight", dynlib: FreeImageLib.}
proc FreeImage_GetLine*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetLine", dynlib: FreeImageLib.}
proc FreeImage_GetPitch*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetPitch", dynlib: FreeImageLib.}
proc FreeImage_GetDIBSize*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetDIBSize", dynlib: FreeImageLib.}
proc FreeImage_GetPalette*(dib: ptr FIBITMAP): ptr RGBQUAD {.
    importc: "FreeImage_GetPalette", dynlib: FreeImageLib.}
proc FreeImage_GetDotsPerMeterX*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetDotsPerMeterX", dynlib: FreeImageLib.}
proc FreeImage_GetDotsPerMeterY*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetDotsPerMeterY", dynlib: FreeImageLib.}
proc FreeImage_SetDotsPerMeterX*(dib: ptr FIBITMAP; res: cuint) {.
    importc: "FreeImage_SetDotsPerMeterX", dynlib: FreeImageLib.}
proc FreeImage_SetDotsPerMeterY*(dib: ptr FIBITMAP; res: cuint) {.
    importc: "FreeImage_SetDotsPerMeterY", dynlib: FreeImageLib.}
proc FreeImage_GetInfoHeader*(dib: ptr FIBITMAP): ptr BITMAPINFOHEADER {.
    importc: "FreeImage_GetInfoHeader", dynlib: FreeImageLib.}
proc FreeImage_GetInfo*(dib: ptr FIBITMAP): ptr BITMAPINFO {.
    importc: "FreeImage_GetInfo", dynlib: FreeImageLib.}
proc FreeImage_GetColorType*(dib: ptr FIBITMAP): FREE_IMAGE_COLOR_TYPE {.
    importc: "FreeImage_GetColorType", dynlib: FreeImageLib.}
proc FreeImage_GetRedMask*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetRedMask", dynlib: FreeImageLib.}
proc FreeImage_GetGreenMask*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetGreenMask", dynlib: FreeImageLib.}
proc FreeImage_GetBlueMask*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetBlueMask", dynlib: FreeImageLib.}
proc FreeImage_GetTransparencyCount*(dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetTransparencyCount", dynlib: FreeImageLib.}
proc FreeImage_GetTransparencyTable*(dib: ptr FIBITMAP): ptr BYTE {.
    importc: "FreeImage_GetTransparencyTable", dynlib: FreeImageLib.}
proc FreeImage_SetTransparent*(dib: ptr FIBITMAP; enabled: BOOL) {.
    importc: "FreeImage_SetTransparent", dynlib: FreeImageLib.}
proc FreeImage_SetTransparencyTable*(dib: ptr FIBITMAP; table: ptr BYTE; 
                                     count: cint) {.
    importc: "FreeImage_SetTransparencyTable", dynlib: FreeImageLib.}
proc FreeImage_IsTransparent*(dib: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_IsTransparent", dynlib: FreeImageLib.}
proc FreeImage_SetTransparentIndex*(dib: ptr FIBITMAP; index: cint) {.
    importc: "FreeImage_SetTransparentIndex", dynlib: FreeImageLib.}
proc FreeImage_GetTransparentIndex*(dib: ptr FIBITMAP): cint {.
    importc: "FreeImage_GetTransparentIndex", dynlib: FreeImageLib.}
proc FreeImage_HasBackgroundColor*(dib: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_HasBackgroundColor", dynlib: FreeImageLib.}
proc FreeImage_GetBackgroundColor*(dib: ptr FIBITMAP; bkcolor: ptr RGBQUAD): BOOL {.
    importc: "FreeImage_GetBackgroundColor", dynlib: FreeImageLib.}
proc FreeImage_SetBackgroundColor*(dib: ptr FIBITMAP; bkcolor: ptr RGBQUAD): BOOL {.
    importc: "FreeImage_SetBackgroundColor", dynlib: FreeImageLib.}
proc FreeImage_GetThumbnail*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_GetThumbnail", dynlib: FreeImageLib.}
proc FreeImage_SetThumbnail*(dib: ptr FIBITMAP; thumbnail: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_SetThumbnail", dynlib: FreeImageLib.}
# ICC profile routines -----------------------------------------------------

proc FreeImage_GetICCProfile*(dib: ptr FIBITMAP): ptr FIICCPROFILE {.
    importc: "FreeImage_GetICCProfile", dynlib: FreeImageLib.}
proc FreeImage_CreateICCProfile*(dib: ptr FIBITMAP; data: pointer; size: clong): ptr FIICCPROFILE {.
    importc: "FreeImage_CreateICCProfile", dynlib: FreeImageLib.}
proc FreeImage_DestroyICCProfile*(dib: ptr FIBITMAP) {.
    importc: "FreeImage_DestroyICCProfile", dynlib: FreeImageLib.}
# Line conversion routines -------------------------------------------------

proc FreeImage_ConvertLine1To4*(target: ptr BYTE; source: ptr BYTE; 
                                width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine1To4", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine8To4*(target: ptr BYTE; source: ptr BYTE; 
                                width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine8To4", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To4_555*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To4_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To4_565*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To4_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine24To4*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine24To4", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine32To4*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine32To4", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine1To8*(target: ptr BYTE; source: ptr BYTE; 
                                width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine1To8", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine4To8*(target: ptr BYTE; source: ptr BYTE; 
                                width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine4To8", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To8_555*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To8_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To8_565*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To8_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine24To8*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine24To8", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine32To8*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine32To8", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine1To16_555*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine1To16_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine4To16_555*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine4To16_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine8To16_555*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine8To16_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16_565_To16_555*(target: ptr BYTE; source: ptr BYTE; 
    width_in_pixels: cint) {.importc: "FreeImage_ConvertLine16_565_To16_555", 
                             dynlib: FreeImageLib.}
proc FreeImage_ConvertLine24To16_555*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine24To16_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine32To16_555*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine32To16_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine1To16_565*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine1To16_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine4To16_565*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine4To16_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine8To16_565*(target: ptr BYTE; source: ptr BYTE; 
                                     width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine8To16_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16_555_To16_565*(target: ptr BYTE; source: ptr BYTE; 
    width_in_pixels: cint) {.importc: "FreeImage_ConvertLine16_555_To16_565", 
                             dynlib: FreeImageLib.}
proc FreeImage_ConvertLine24To16_565*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine24To16_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine32To16_565*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine32To16_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine1To24*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine1To24", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine4To24*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine4To24", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine8To24*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine8To24", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To24_555*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To24_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To24_565*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To24_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine32To24*(target: ptr BYTE; source: ptr BYTE; 
                                  width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine32To24", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine1To32*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine1To32", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine4To32*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine4To32", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine8To32*(target: ptr BYTE; source: ptr BYTE; 
                                 width_in_pixels: cint; palette: ptr RGBQUAD) {.
    importc: "FreeImage_ConvertLine8To32", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To32_555*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To32_555", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine16To32_565*(target: ptr BYTE; source: ptr BYTE; 
                                      width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine16To32_565", dynlib: FreeImageLib.}
proc FreeImage_ConvertLine24To32*(target: ptr BYTE; source: ptr BYTE; 
                                  width_in_pixels: cint) {.
    importc: "FreeImage_ConvertLine24To32", dynlib: FreeImageLib.}
# Smart conversion routines ------------------------------------------------

proc FreeImage_ConvertTo4Bits*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertTo4Bits", dynlib: FreeImageLib.}
proc FreeImage_ConvertTo8Bits*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertTo8Bits", dynlib: FreeImageLib.}
proc FreeImage_ConvertToGreyscale*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToGreyscale", dynlib: FreeImageLib.}
proc FreeImage_ConvertTo16Bits555*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertTo16Bits555", dynlib: FreeImageLib.}
proc FreeImage_ConvertTo16Bits565*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertTo16Bits565", dynlib: FreeImageLib.}
proc FreeImage_ConvertTo24Bits*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertTo24Bits", dynlib: FreeImageLib.}
proc FreeImage_ConvertTo32Bits*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertTo32Bits", dynlib: FreeImageLib.}
proc FreeImage_ColorQuantize*(dib: ptr FIBITMAP; quantize: FREE_IMAGE_QUANTIZE): ptr FIBITMAP {.
    importc: "FreeImage_ColorQuantize", dynlib: FreeImageLib.}
proc FreeImage_ColorQuantizeEx*(dib: ptr FIBITMAP; 
                                quantize: FREE_IMAGE_QUANTIZE; 
                                PaletteSize: cint; ReserveSize: cint; 
                                ReservePalette: ptr RGBQUAD): ptr FIBITMAP {.
    importc: "FreeImage_ColorQuantizeEx", dynlib: FreeImageLib.}
proc FreeImage_Threshold*(dib: ptr FIBITMAP; T: BYTE): ptr FIBITMAP {.
    importc: "FreeImage_Threshold", dynlib: FreeImageLib.}
proc FreeImage_Dither*(dib: ptr FIBITMAP; algorithm: eFREE_IMAGE_DITHER): ptr FIBITMAP {.
    importc: "FreeImage_Dither", dynlib: FreeImageLib.}
proc FreeImage_ConvertFromRawBits*(bits: ptr BYTE; width: cint; height: cint; 
                                   pitch: cint; bpp: cuint; red_mask: cuint; 
                                   green_mask: cuint; blue_mask: cuint; 
                                   topdown: BOOL): ptr FIBITMAP {.
    importc: "FreeImage_ConvertFromRawBits", dynlib: FreeImageLib.}
proc FreeImage_ConvertToRawBits*(bits: ptr BYTE; dib: ptr FIBITMAP; pitch: cint; 
                                 bpp: cuint; red_mask: cuint; green_mask: cuint; 
                                 blue_mask: cuint; topdown: BOOL) {.
    importc: "FreeImage_ConvertToRawBits", dynlib: FreeImageLib.}
proc FreeImage_ConvertToFloat*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToFloat", dynlib: FreeImageLib.}
proc FreeImage_ConvertToRGBF*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToRGBF", dynlib: FreeImageLib.}
proc FreeImage_ConvertToUINT16*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToUINT16", dynlib: FreeImageLib.}
proc FreeImage_ConvertToRGB16*(dib: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToRGB16", dynlib: FreeImageLib.}
proc FreeImage_ConvertToStandardType*(src: ptr FIBITMAP; scale_linear: BOOL): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToStandardType", dynlib: FreeImageLib.}
proc FreeImage_ConvertToType*(src: ptr FIBITMAP; dst_type: FREE_IMAGE_TYPE; 
                              scale_linear: BOOL): ptr FIBITMAP {.
    importc: "FreeImage_ConvertToType", dynlib: FreeImageLib.}
# tone mapping operators

proc FreeImage_ToneMapping*(dib: ptr FIBITMAP; tmo: FREE_IMAGE_TMO; 
                            first_param: cdouble; second_param: cdouble): ptr FIBITMAP {.
    importc: "FreeImage_ToneMapping", dynlib: FreeImageLib.}
proc FreeImage_TmoDrago03*(src: ptr FIBITMAP; gamma: cdouble; exposure: cdouble): ptr FIBITMAP {.
    importc: "FreeImage_TmoDrago03", dynlib: FreeImageLib.}
proc FreeImage_TmoReinhard05*(src: ptr FIBITMAP; intensity: cdouble; 
                              contrast: cdouble): ptr FIBITMAP {.
    importc: "FreeImage_TmoReinhard05", dynlib: FreeImageLib.}
proc FreeImage_TmoReinhard05Ex*(src: ptr FIBITMAP; intensity: cdouble; 
                                contrast: cdouble; adaptation: cdouble; 
                                color_correction: cdouble): ptr FIBITMAP {.
    importc: "FreeImage_TmoReinhard05Ex", dynlib: FreeImageLib.}
proc FreeImage_TmoFattal02*(src: ptr FIBITMAP; color_saturation: cdouble; 
                            attenuation: cdouble): ptr FIBITMAP {.
    importc: "FreeImage_TmoFattal02", dynlib: FreeImageLib.}
# ZLib interface -----------------------------------------------------------

proc FreeImage_ZLibCompress*(target: ptr BYTE; target_size: DWORD; 
                             source: ptr BYTE; source_size: DWORD): DWORD {.
    importc: "FreeImage_ZLibCompress", dynlib: FreeImageLib.}
proc FreeImage_ZLibUncompress*(target: ptr BYTE; target_size: DWORD; 
                               source: ptr BYTE; source_size: DWORD): DWORD {.
    importc: "FreeImage_ZLibUncompress", dynlib: FreeImageLib.}
proc FreeImage_ZLibGZip*(target: ptr BYTE; target_size: DWORD; source: ptr BYTE; 
                         source_size: DWORD): DWORD {.
    importc: "FreeImage_ZLibGZip", dynlib: FreeImageLib.}
proc FreeImage_ZLibGUnzip*(target: ptr BYTE; target_size: DWORD; 
                           source: ptr BYTE; source_size: DWORD): DWORD {.
    importc: "FreeImage_ZLibGUnzip", dynlib: FreeImageLib.}
proc FreeImage_ZLibCRC32*(crc: DWORD; source: ptr BYTE; source_size: DWORD): DWORD {.
    importc: "FreeImage_ZLibCRC32", dynlib: FreeImageLib.}
# --------------------------------------------------------------------------
# Metadata routines --------------------------------------------------------
# --------------------------------------------------------------------------
# tag creation / destruction

proc FreeImage_CreateTag*(): ptr FITAG {.importc: "FreeImage_CreateTag", 
    dynlib: FreeImageLib.}
proc FreeImage_DeleteTag*(tag: ptr FITAG) {.importc: "FreeImage_DeleteTag", 
    dynlib: FreeImageLib.}
proc FreeImage_CloneTag*(tag: ptr FITAG): ptr FITAG {.
    importc: "FreeImage_CloneTag", dynlib: FreeImageLib.}
# tag getters and setters

proc FreeImage_GetTagKey*(tag: ptr FITAG): cstring {.
    importc: "FreeImage_GetTagKey", dynlib: FreeImageLib.}
proc FreeImage_GetTagDescription*(tag: ptr FITAG): cstring {.
    importc: "FreeImage_GetTagDescription", dynlib: FreeImageLib.}
proc FreeImage_GetTagID*(tag: ptr FITAG): WORD {.importc: "FreeImage_GetTagID", 
    dynlib: FreeImageLib.}
proc FreeImage_GetTagType*(tag: ptr FITAG): FREE_IMAGE_MDTYPE {.
    importc: "FreeImage_GetTagType", dynlib: FreeImageLib.}
proc FreeImage_GetTagCount*(tag: ptr FITAG): DWORD {.
    importc: "FreeImage_GetTagCount", dynlib: FreeImageLib.}
proc FreeImage_GetTagLength*(tag: ptr FITAG): DWORD {.
    importc: "FreeImage_GetTagLength", dynlib: FreeImageLib.}
proc FreeImage_GetTagValue*(tag: ptr FITAG): pointer {.
    importc: "FreeImage_GetTagValue", dynlib: FreeImageLib.}
proc FreeImage_SetTagKey*(tag: ptr FITAG; key: cstring): BOOL {.
    importc: "FreeImage_SetTagKey", dynlib: FreeImageLib.}
proc FreeImage_SetTagDescription*(tag: ptr FITAG; description: cstring): BOOL {.
    importc: "FreeImage_SetTagDescription", dynlib: FreeImageLib.}
proc FreeImage_SetTagID*(tag: ptr FITAG; id: WORD): BOOL {.
    importc: "FreeImage_SetTagID", dynlib: FreeImageLib.}
proc FreeImage_SetTagType*(tag: ptr FITAG; typen: FREE_IMAGE_MDTYPE): BOOL {.
    importc: "FreeImage_SetTagType", dynlib: FreeImageLib.}
proc FreeImage_SetTagCount*(tag: ptr FITAG; count: DWORD): BOOL {.
    importc: "FreeImage_SetTagCount", dynlib: FreeImageLib.}
proc FreeImage_SetTagLength*(tag: ptr FITAG; length: DWORD): BOOL {.
    importc: "FreeImage_SetTagLength", dynlib: FreeImageLib.}
proc FreeImage_SetTagValue*(tag: ptr FITAG; value: pointer): BOOL {.
    importc: "FreeImage_SetTagValue", dynlib: FreeImageLib.}
# iterator

proc FreeImage_FindFirstMetadata*(model: FREE_IMAGE_MDMODEL; dib: ptr FIBITMAP; 
                                  tag: ptr ptr FITAG): ptr FIMETADATA {.
    importc: "FreeImage_FindFirstMetadata", dynlib: FreeImageLib.}
proc FreeImage_FindNextMetadata*(mdhandle: ptr FIMETADATA; tag: ptr ptr FITAG): BOOL {.
    importc: "FreeImage_FindNextMetadata", dynlib: FreeImageLib.}
proc FreeImage_FindCloseMetadata*(mdhandle: ptr FIMETADATA) {.
    importc: "FreeImage_FindCloseMetadata", dynlib: FreeImageLib.}
# metadata setter and getter

proc FreeImage_SetMetadata*(model: FREE_IMAGE_MDMODEL; dib: ptr FIBITMAP; 
                            key: cstring; tag: ptr FITAG): BOOL {.
    importc: "FreeImage_SetMetadata", dynlib: FreeImageLib.}
proc FreeImage_GetMetadata*(model: FREE_IMAGE_MDMODEL; dib: ptr FIBITMAP; 
                            key: cstring; tag: ptr ptr FITAG): BOOL {.
    importc: "FreeImage_GetMetadata", dynlib: FreeImageLib.}
# helpers

proc FreeImage_GetMetadataCount*(model: FREE_IMAGE_MDMODEL; dib: ptr FIBITMAP): cuint {.
    importc: "FreeImage_GetMetadataCount", dynlib: FreeImageLib.}
proc FreeImage_CloneMetadata*(dst: ptr FIBITMAP; src: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_CloneMetadata", dynlib: FreeImageLib.}
# tag to C string conversion

proc FreeImage_TagToString*(model: FREE_IMAGE_MDMODEL; tag: ptr FITAG; 
                            Make: cstring): cstring {.
    importc: "FreeImage_TagToString", dynlib: FreeImageLib.}
# --------------------------------------------------------------------------
# Image manipulation toolkit -----------------------------------------------
# --------------------------------------------------------------------------
# rotation and flipping
#/ @deprecated see FreeImage_Rotate

proc FreeImage_RotateClassic*(dib: ptr FIBITMAP; angle: cdouble): ptr FIBITMAP {.
    importc: "FreeImage_RotateClassic", dynlib: FreeImageLib.}
proc FreeImage_Rotate*(dib: ptr FIBITMAP; angle: cdouble; bkcolor: pointer): ptr FIBITMAP {.
    importc: "FreeImage_Rotate", dynlib: FreeImageLib.}
proc FreeImage_RotateEx*(dib: ptr FIBITMAP; angle: cdouble; x_shift: cdouble; 
                         y_shift: cdouble; x_origin: cdouble; y_origin: cdouble; 
                         use_mask: BOOL): ptr FIBITMAP {.
    importc: "FreeImage_RotateEx", dynlib: FreeImageLib.}
proc FreeImage_FlipHorizontal*(dib: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_FlipHorizontal", dynlib: FreeImageLib.}
proc FreeImage_FlipVertical*(dib: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_FlipVertical", dynlib: FreeImageLib.}
proc FreeImage_JPEGTransform*(src_file: cstring; dst_file: cstring; 
                              operation: FREE_IMAGE_JPEG_OPERATION; 
                              perfect: BOOL): BOOL {.
    importc: "FreeImage_JPEGTransform", dynlib: FreeImageLib.}
proc FreeImage_JPEGTransformU*(src_file: ptr uint16; dst_file: ptr uint16; 
                               operation: FREE_IMAGE_JPEG_OPERATION; 
                               perfect: BOOL): BOOL {.
    importc: "FreeImage_JPEGTransformU", dynlib: FreeImageLib.}
# upsampling / downsampling

proc FreeImage_Rescale*(dib: ptr FIBITMAP; dst_width: cint; dst_height: cint; 
                        filter: FREE_IMAGE_FILTER): ptr FIBITMAP {.
    importc: "FreeImage_Rescale", dynlib: FreeImageLib.}
proc FreeImage_MakeThumbnail*(dib: ptr FIBITMAP; max_pixel_size: cint; 
                              convert: BOOL): ptr FIBITMAP {.
    importc: "FreeImage_MakeThumbnail", dynlib: FreeImageLib.}
# color manipulation routines (point operations)

proc FreeImage_AdjustCurve*(dib: ptr FIBITMAP; LUT: ptr BYTE; 
                            channel: FREE_IMAGE_COLOR_CHANNEL): BOOL {.
    importc: "FreeImage_AdjustCurve", dynlib: FreeImageLib.}
proc FreeImage_AdjustGamma*(dib: ptr FIBITMAP; gamma: cdouble): BOOL {.
    importc: "FreeImage_AdjustGamma", dynlib: FreeImageLib.}
proc FreeImage_AdjustBrightness*(dib: ptr FIBITMAP; percentage: cdouble): BOOL {.
    importc: "FreeImage_AdjustBrightness", dynlib: FreeImageLib.}
proc FreeImage_AdjustContrast*(dib: ptr FIBITMAP; percentage: cdouble): BOOL {.
    importc: "FreeImage_AdjustContrast", dynlib: FreeImageLib.}
proc FreeImage_Invert*(dib: ptr FIBITMAP): BOOL {.importc: "FreeImage_Invert", 
    dynlib: FreeImageLib.}
proc FreeImage_GetHistogram*(dib: ptr FIBITMAP; histo: ptr DWORD; 
                             channel: FREE_IMAGE_COLOR_CHANNEL): BOOL {.
    importc: "FreeImage_GetHistogram", dynlib: FreeImageLib.}
proc FreeImage_GetAdjustColorsLookupTable*(LUT: ptr BYTE; brightness: cdouble; 
    contrast: cdouble; gamma: cdouble; invert: BOOL): cint {.
    importc: "FreeImage_GetAdjustColorsLookupTable", dynlib: FreeImageLib.}
proc FreeImage_AdjustColors*(dib: ptr FIBITMAP; brightness: cdouble; 
                             contrast: cdouble; gamma: cdouble; invert: BOOL): BOOL {.
    importc: "FreeImage_AdjustColors", dynlib: FreeImageLib.}
proc FreeImage_ApplyColorMapping*(dib: ptr FIBITMAP; srccolors: ptr RGBQUAD; 
                                  dstcolors: ptr RGBQUAD; count: cuint; 
                                  ignore_alpha: BOOL; swap: BOOL): cuint {.
    importc: "FreeImage_ApplyColorMapping", dynlib: FreeImageLib.}
proc FreeImage_SwapColors*(dib: ptr FIBITMAP; color_a: ptr RGBQUAD; 
                           color_b: ptr RGBQUAD; ignore_alpha: BOOL): cuint {.
    importc: "FreeImage_SwapColors", dynlib: FreeImageLib.}
proc FreeImage_ApplyPaletteIndexMapping*(dib: ptr FIBITMAP; 
    srcindices: ptr BYTE; dstindices: ptr BYTE; count: cuint; swap: BOOL): cuint {.
    importc: "FreeImage_ApplyPaletteIndexMapping", dynlib: FreeImageLib.}
proc FreeImage_SwapPaletteIndices*(dib: ptr FIBITMAP; index_a: ptr BYTE; 
                                   index_b: ptr BYTE): cuint {.
    importc: "FreeImage_SwapPaletteIndices", dynlib: FreeImageLib.}
# channel processing routines

proc FreeImage_GetChannel*(dib: ptr FIBITMAP; channel: FREE_IMAGE_COLOR_CHANNEL): ptr FIBITMAP {.
    importc: "FreeImage_GetChannel", dynlib: FreeImageLib.}
proc FreeImage_SetChannel*(dst: ptr FIBITMAP; src: ptr FIBITMAP; 
                           channel: FREE_IMAGE_COLOR_CHANNEL): BOOL {.
    importc: "FreeImage_SetChannel", dynlib: FreeImageLib.}
proc FreeImage_GetComplexChannel*(src: ptr FIBITMAP; 
                                  channel: FREE_IMAGE_COLOR_CHANNEL): ptr FIBITMAP {.
    importc: "FreeImage_GetComplexChannel", dynlib: FreeImageLib.}
proc FreeImage_SetComplexChannel*(dst: ptr FIBITMAP; src: ptr FIBITMAP; 
                                  channel: FREE_IMAGE_COLOR_CHANNEL): BOOL {.
    importc: "FreeImage_SetComplexChannel", dynlib: FreeImageLib.}
# copy / paste / composite routines

proc FreeImage_Copy*(dib: ptr FIBITMAP; left: cint; top: cint; right: cint; 
                     bottom: cint): ptr FIBITMAP {.importc: "FreeImage_Copy", 
    dynlib: FreeImageLib.}
proc FreeImage_Paste*(dst: ptr FIBITMAP; src: ptr FIBITMAP; left: cint; 
                      top: cint; alpha: cint): BOOL {.
    importc: "FreeImage_Paste", dynlib: FreeImageLib.}
proc FreeImage_Composite*(fg: ptr FIBITMAP; useFileBkg: BOOL; 
                          appBkColor: ptr RGBQUAD; bg: ptr FIBITMAP): ptr FIBITMAP {.
    importc: "FreeImage_Composite", dynlib: FreeImageLib.}
proc FreeImage_JPEGCrop*(src_file: cstring; dst_file: cstring; left: cint; 
                         top: cint; right: cint; bottom: cint): BOOL {.
    importc: "FreeImage_JPEGCrop", dynlib: FreeImageLib.}
proc FreeImage_JPEGCropU*(src_file: ptr uint16; dst_file: ptr uint16; 
                          left: cint; top: cint; right: cint; bottom: cint): BOOL {.
    importc: "FreeImage_JPEGCropU", dynlib: FreeImageLib.}
proc FreeImage_PreMultiplyWithAlpha*(dib: ptr FIBITMAP): BOOL {.
    importc: "FreeImage_PreMultiplyWithAlpha", dynlib: FreeImageLib.}
# background filling routines

proc FreeImage_FillBackground*(dib: ptr FIBITMAP; color: pointer; options: cint): BOOL {.
    importc: "FreeImage_FillBackground", dynlib: FreeImageLib.}
proc FreeImage_EnlargeCanvas*(src: ptr FIBITMAP; left: cint; top: cint; 
                              right: cint; bottom: cint; color: pointer; 
                              options: cint): ptr FIBITMAP {.
    importc: "FreeImage_EnlargeCanvas", dynlib: FreeImageLib.}
proc FreeImage_AllocateEx*(width: cint; height: cint; bpp: cint; 
                           color: ptr RGBQUAD; options: cint; 
                           palette: ptr RGBQUAD; red_mask: cuint; 
                           green_mask: cuint; blue_mask: cuint): ptr FIBITMAP {.
    importc: "FreeImage_AllocateEx", dynlib: FreeImageLib.}
proc FreeImage_AllocateExT*(typen: FREE_IMAGE_TYPE; width: cint; height: cint; 
                            bpp: cint; color: pointer; options: cint; 
                            palette: ptr RGBQUAD; red_mask: cuint; 
                            green_mask: cuint; blue_mask: cuint): ptr FIBITMAP {.
    importc: "FreeImage_AllocateExT", dynlib: FreeImageLib.}
# miscellaneous algorithms

proc FreeImage_MultigridPoissonSolver*(Laplacian: ptr FIBITMAP; ncycle: cint): ptr FIBITMAP {.
    importc: "FreeImage_MultigridPoissonSolver", dynlib: FreeImageLib.}

{.pop.}
