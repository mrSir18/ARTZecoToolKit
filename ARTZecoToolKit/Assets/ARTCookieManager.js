//
//  ARTCookieManager.swift
//  ARTZecoToolKit
//
//  Created by mrSir18 on 2024/8/19.
//

/// 获取当前网页所有的 Cookie 名称
const app_cookieNames = document.cookie
    .split('; ')
    .map(cookie => cookie.split('=')[0]);


/// 获取网页根域名
const app_rootDomain = (() => {
    const domain = document.domain;
    const topLevelDomains = new Set([
        'com', 'cn', 'net', 'org', 'cc', 'co', 'top', 'vip', 'club', 'info', 'tech', 'gov', 'edu', 'mil'
    ]);
    
    const parts = domain.split('.');
    let i = parts.length - 1;
    while (i >= 0 && (topLevelDomains.has(parts[i]) || !isNaN(parts[i]))) {
        i--;
    }
    return i > 0 ? `.${parts.slice(i).join('.')}` : domain;
})();

/// 设置cookie，并将其应用于根域名
function app_setCookie(name, value) {
    const encodedValue = encodeURIComponent(value);
    document.cookie = `${name}=${encodedValue}; domain=${app_rootDomain}; path=/`;
}

/// 删除指定的cookie，并从根域名删除
function app_deleteCookie(name) {
    const pastDate = new Date();
    pastDate.setTime(pastDate.getTime() - 1);
    document.cookie = `${name}=; domain=${app_rootDomain}; expires=${pastDate.toUTCString()}; path=/`;
}
