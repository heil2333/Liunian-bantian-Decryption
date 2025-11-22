import pyperclip

def auto_decode(cipher_text):
    """自动从密文中提取字典并解密"""
    if len(cipher_text) < 4:
        return "错误：密文长度不足"

    # 从密文中提取字典
    bd = [
        cipher_text[2],  # 字典[0] = 前缀的第3个字符 = '兽'
        cipher_text[1],  # 字典[1] = 前缀的第2个字符 = '音'
        cipher_text[-1], # 字典[2] = 后缀 = '翻'
        cipher_text[0]   # 字典[3] = 前缀的第1个字符 = '译'
    ]
    
    print(f"提取的字典: {bd}")
    
    # 根据加密规则，前缀是字典的第4、2、1个字符，后缀是第3个字符
    prefix = bd[3] + bd[1] + bd[0]  # 第4、2、1个字符
    suffix = bd[2]  # 第3个字符
    
    print(f"期望的前缀: {prefix}, 后缀: {suffix}")
    print(f"实际的前缀: {cipher_text[:3]}, 后缀: {cipher_text[-1]}")
    
    # 检查是否有正确的前缀和后缀
    if not (cipher_text.startswith(prefix) and cipher_text.endswith(suffix)):
        return "错误：无法识别密文格式 - 前缀或后缀不匹配"
    
    # 提取核心部分
    core_str = cipher_text[3:-1]
    
    # 确保核心部分长度为偶数
    if len(core_str) % 2 != 0:
        return "错误：密文格式不正确 - 核心部分长度不是偶数"
    
    # 解密核心部分
    hex_str = ""
    for i in range(0, len(core_str), 2):
        try:
            pos1 = bd.index(core_str[i])
            pos2 = bd.index(core_str[i+1])
            k = (pos1 * 4 + pos2) - (i//2 % 16)
            if k < 0:
                k += 16
            hex_str += hex(k)[2:]
        except ValueError:
            return f"错误：密文中包含无效字符 '{core_str[i]}' 或 '{core_str[i+1]}'"
    
    # 将十六进制转换为字符串
    result = ""
    for i in range(0, len(hex_str), 4):
        try:
            if i+4 <= len(hex_str):
                code_point = int(hex_str[i:i+4], 16)
                result += chr(code_point)
        except:
            result += "�"  # 替换无效字符
    
    return result

def main():
    """主函数"""
    try:
        # 获取剪贴板内容
        clipboard_text = pyperclip.paste().strip()
        
        print(f"从剪贴板读取的内容长度: {len(clipboard_text)}")
        print(f"前5个字符: {clipboard_text[:5]}")
        print(f"后5个字符: {clipboard_text[-5:]}")
        
        if clipboard_text:
            # 尝试解密
            result = auto_decode(clipboard_text)
            
            # 输出结果到剪贴板
            pyperclip.copy(result)
            
            # 显示结果
            print("\n解密结果:")
            print(f"{result}")
        else:
            print("剪贴板为空或只包含空白字符")
        
        input("\n按Enter键退出...")
    
    except Exception as e:
        print(f"发生错误: {str(e)}")
        import traceback
        traceback.print_exc()
        input("按Enter键退出...")

if __name__ == '__main__':
    # 检查是否安装了pyperclip
    try:
        import pyperclip
    except ImportError:
        print("错误：未安装pyperclip库")
        print("请运行: pip install pyperclip")
        input("按Enter键退出...")
        exit(1)
    
    main()